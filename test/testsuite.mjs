import * as fs from "fs";

import {initializeABAP} from "../output/init.mjs";
await initializeABAP();

const html = await abap.Classes["CL_TESTSUITE"].run();

fs.writeFileSync("testsuite.html", html.get());