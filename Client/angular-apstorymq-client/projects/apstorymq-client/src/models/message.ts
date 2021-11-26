import { Properties } from './properties';
import { Header } from './header';

export class Message {
    public header!: Header;
    public properties!: Properties[];
    public body: any;
}
