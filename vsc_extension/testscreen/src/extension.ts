import * as vscode from 'vscode';
import * as path from 'path';
import * as fs from 'fs';

export function activate(context: vscode.ExtensionContext) {
	let disposable = vscode.commands.registerCommand('extension.openScreen', (test: vscode.TestItem) => {
		// Check if test.uri is defined
		if (test.uri) {
			// test.id format: TEST:*:* {platform} {language} {id}:*"
			const testId = test.id;
			const colonIndex = testId.lastIndexOf(":");
			if (colonIndex === -1) {
				vscode.window.showErrorMessage('Screen file not found: Id not found.');
			} else {
				const spaceIndexId = testId.lastIndexOf(" ", colonIndex);
				if (spaceIndexId === -1) {
					vscode.window.showErrorMessage('Screen file not found: Id not found.');
				}
				else {
					const id = testId.substring(spaceIndexId + 1, colonIndex);
					const spaceIndexLanguage = testId.lastIndexOf(" ", spaceIndexId - 1);
					if (spaceIndexLanguage === -1) {
						vscode.window.showErrorMessage('Screen file not found: Language not found.');
					} else {
						const language = testId.substring(spaceIndexLanguage + 1, spaceIndexId);
					    const spaceIndexPlatform = testId.lastIndexOf(" ", spaceIndexLanguage - 1);
						if (spaceIndexPlatform === -1) {
							vscode.window.showErrorMessage('Screen file not found: Platform not found.');
						} else {
							const platform = testId.substring(spaceIndexPlatform + 1, spaceIndexLanguage);
							const screenPath = `${path.dirname(test.uri.fsPath)}/screens/${platform}_${language}_${id}.png`;
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
			}						
		} else {
			// If test.uri is not defined, show an error message
			vscode.window.showErrorMessage('Test URI not found');
		}
	});

	context.subscriptions.push(disposable);
}
