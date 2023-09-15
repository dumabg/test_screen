import * as vscode from 'vscode';
import * as path from 'path';
import * as fs from 'fs';

export function activate(context: vscode.ExtensionContext) {
	let disposable = vscode.commands.registerCommand('extension.openScreen', (test: vscode.TestItem) => {
		// Check if test.uri is defined
		if (test.uri) {
			// test.label format: "name ¬goldenDir". ¬goldenDir only appears if testScreenUI has goldenDir property.
			// name: {id}:*
			const label = test.label;
			const colonIndex = label.indexOf(":");
			if (colonIndex === -1) {
				vscode.window.showErrorMessage('Screen file not found: Id not found.');
			} else {
				const id = label.substring(0, colonIndex);
				// test.id format: TEST:*:* {platform} {language} {id}:*"
				const testId = test.id;
				const idIndex = testId.lastIndexOf(label) - 1;
				const spaceIndexLanguage = testId.lastIndexOf(" ", idIndex - 1);
				if (spaceIndexLanguage === -1) {
					vscode.window.showErrorMessage('Screen file not found: Language not found.');
				} else {
					const language = testId.substring(spaceIndexLanguage + 1, idIndex);
					const spaceIndexPlatform = testId.lastIndexOf(" ", spaceIndexLanguage - 1);
					if (spaceIndexPlatform === -1) {
						vscode.window.showErrorMessage('Screen file not found: Platform not found.');
					} else {
						const platform = testId.substring(spaceIndexPlatform + 1, spaceIndexLanguage);
						// test.label format: "name ¬goldenDir". ¬goldenDir only appears if testScreenUI has goldenDir property.							
						// This means that inside the screens directory a subdirectory with name goldenDir is created.							
						const startSubdirectoryIndex = label.lastIndexOf('¬');
						const subdirectory = startSubdirectoryIndex === -1 ?
							'' :
							`/${label.substring(startSubdirectoryIndex + 1, label.length)}`;
						const screenPath = `${path.dirname(test.uri.fsPath)}/screens${subdirectory}/${platform}_${language}_${id}.png`;
						// Check if the screen file exists
						if (fs.existsSync(screenPath)) {
							// If the screen file exists, open it
							vscode.commands.executeCommand('vscode.open', vscode.Uri.file(screenPath));
						} else {
							// If the screen file does not exist, show an error message
							vscode.window.showErrorMessage(`Screen file not found: ${screenPath}`);
						}
					}
				}
			}
		} else {
			// If test.uri is not defined, show an error message
			vscode.window.showErrorMessage('Test URI not found');
		}
	});

	context.subscriptions.push(disposable);
}
