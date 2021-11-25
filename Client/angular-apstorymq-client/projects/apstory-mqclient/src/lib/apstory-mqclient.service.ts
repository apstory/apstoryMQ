import { Injectable } from '@angular/core';
import { Http, RequestOptions } from '@angular/http';
import { Message } from '../model/message';
import { Messages } from '../model/messages';

@Injectable({
  providedIn: 'root'
})
export class ApstoryMQClientService {

  constructor(public http: Http) { }

  private apiUrl: string;
  private client: string;
  private key: string;

  async init(apiUrl: string, key: string, client: string) {
    this.apiUrl = apiUrl;
    this.key = key;
    this.client = client;
  }

  async createSubscription(topic: string) {
    try {
      await this.http.get(this.apiUrl + 'message?key=' + this.key + '&client=' + this.client + '&topic=' + topic + '&pageSize=1').toPromise();
    } catch (error) {
      await this.handleError(error);
    }
  }

  async publish(topic: string, messages: Message[]): Promise<Message[]> {
    try {
      const response = await this.http.post(this.apiUrl + 'message?key=' + this.key + '&client=' + this.client + '&topic=' + topic, messages).toPromise();
      return response.json();
    } catch (error) {
      await this.handleError(error);
    }
  }

  async subscribe(topic: string): Promise<Messages> {
    try {
      const response = await this.http.get(this.apiUrl + 'message?key=' + this.key + '&client=' + this.client + '&topic=' + topic + '&pageSize=200').toPromise();
      return response.json();
    } catch (error) {
      await this.handleError(error);
    }
  }

  async commit(topic: string, messageId: number): Promise<Boolean> {
    try {
      const response = await this.http.delete(this.apiUrl + 'message/' + messageId + '?key=' + this.key + '&client=' + this.client + '&topic=' + topic).toPromise();
      return response.json();
    } catch (error) {
      await this.handleError(error);
    }
  }

  async commitMessageList(topic: string, messages: Message[]): Promise<Message[]> {
    try {
      const response = await this.http.delete(this.apiUrl + 'message/?key=' + this.key + '&client=' + this.client + '&topic=' + topic,
        new RequestOptions({
          body: messages
        })).toPromise();
      return response.json();
    } catch (error) {
      await this.handleError(error);
    }
  }

  private async handleError(error: Error) {
    console.error(error);
  }

}
