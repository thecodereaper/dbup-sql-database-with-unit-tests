using System;
using System.Linq;
using DbUp;
using DbUp.Engine;
using DbUp.Helpers;
using DbUp.ScriptProviders;

namespace Demo.Database
{
    internal sealed class Program
    {
        private const string SRC_PATH = "./Scripts/src";
        private const string TESTS_PATH = "./Scripts/tests";

        internal static int Main(string[] args)
        {
            string connectionString = args.FirstOrDefault();

            bool dropDatabase = Convert.ToBoolean(args[1]);
            bool installTests = Convert.ToBoolean(args[2]);

            return installTests ? InstallTests(connectionString) : RunDatabaseUpdate(connectionString, dropDatabase);
        }

        private static int RunDatabaseUpdate(string connectionString, bool dropDatabase)
        {
            if (dropDatabase)
                DropDatabase.For.SqlDatabase(connectionString);

            EnsureDatabase.For.SqlDatabase(connectionString);

            UpgradeEngine upgradeEngine = DeployChanges
                .To
                .SqlDatabase(connectionString)
                .WithScriptsFromFileSystem(SRC_PATH, new FileSystemScriptOptions {IncludeSubDirectories = true})
                .LogToConsole()
                .WithTransaction()
                .Build();

            DatabaseUpgradeResult databaseUpgradeResult = upgradeEngine.PerformUpgrade();

            return !databaseUpgradeResult.Successful ? ShowError(databaseUpgradeResult.Error) : ShowSuccess();
        }

        private static int InstallTests(string connectionString)
        {
            UpgradeEngine upgradeEngine = DeployChanges
                .To
                .SqlDatabase(connectionString)
                .WithScriptsFromFileSystem(TESTS_PATH, new FileSystemScriptOptions {IncludeSubDirectories = true})
                .JournalTo(new NullJournal())
                .Build();

            DatabaseUpgradeResult databaseUpgradeResult = upgradeEngine.PerformUpgrade();

            return !databaseUpgradeResult.Successful ? ShowError(databaseUpgradeResult.Error) : ShowSuccess();
        }

        private static int ShowError(Exception ex)
        {
            Console.ForegroundColor = ConsoleColor.Red;
            Console.WriteLine(ex);
            Console.ResetColor();

            return -1;
        }

        private static int ShowSuccess()
        {
            Console.ForegroundColor = ConsoleColor.Green;
            Console.WriteLine("Success!");
            Console.ResetColor();

            return 0;
        }
    }
}
