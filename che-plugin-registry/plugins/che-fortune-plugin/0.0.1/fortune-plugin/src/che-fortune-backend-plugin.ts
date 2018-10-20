/**
 * Generated using theia-plugin-generator
 */

import * as theia from '@theia/plugin';
import * as childprocess from 'child_process'

export function start() {
    const informationMessageTestCommand = {
        id: 'fortune-command',
        label: "Tell me a fortune"
    };
    theia.commands.registerCommand(informationMessageTestCommand, (...args: any[]) => {
        theia.window.showInformationMessage(fortune());
        let channel: theia.OutputChannel = theia.window.createOutputChannel("fortune");
        channel.show();
        channel.append(fortune());

    });

}

function fortune(): string {
    try {
        return childprocess.execSync("fortune").toString();
    } catch (error) {
        return 'Unable to invoke fortune: tool is missing';
    }
}


export function stop() {

}
