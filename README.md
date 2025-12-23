# ConfigSettingsExtract
Configuration setting extractor to a CSV file

When working with InterSystems Interoperability (Iris / Ensemble / Health Connect), configuration data is often spread across many production items: services, processes, operations, adapters, and their settings.

A common operational or security need is to answer questions like:

- Which interfaces reference file system paths?
- Where are directories, network shares, or absolute paths configured?
- Can I quickly audit or document this information across all my productions?
- The ObjectScript utility below solves exactly that problem by exporting selected configuration settings into a CSV file.

This script:

1. Loops through all existing namespaces
2. Queries all Interoperability configuration items (Ens_Config.Item) across all namespaces
3. Iterates through each item’s Settings
4. Extracts file system/URL paths (values containing :, /, or \)
5. Writes the results into a CSV file, grouped by Category
6. Produces an audit-friendly output you can open in Excel or share with operations/security teams Typical Use Cases

You should use this utility when you need to:

🔍 Audit file system usage across a productions
🛡 Review security exposure (local paths, network shares, database connections)
📄 Document configuration for migrations, upgrades, or DR planning
🔄 Compare environments (DEV vs TEST vs PROD)
🧹 Cleanup legacy or unused paths
This is especially useful in large instances with several productions using many interfaces and adapters.



# Output Format
The generated CSV contains the following columns:
Namespace, Category, Item Name, Class Name, Property Name, Value

Additionally:

- Configuration items are grouped by Category
- Only relevant settings paths are exported - you can easily change the logic to export using the setting's name (such as "DSN" for SQL connections) or any other setting's value.
- Easy to filter and analyze in Excel

Run the utility from the terminal and provide the parameter for the full path and csv name.
for example:
> do ##class(Test.Properties).GetData("c:\temp\extract.csv")



Notes & Tips
🧪 Test in non-PROD first if you’re unsure about permissions
📂 Ensure the target directory exists and is writable by IRIS/Health Connect
🔎 You can easily extend the logic to:
- Export additional properties
- Filter by category or class
- Mask sensitive values (passwords)
- Change logic for relevant data
clear, searchable audit artifact—without touching the Management Portal.

If you extend or improve it, feel free to share your enhancements with the community.
