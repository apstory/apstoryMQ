import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Message } from '../models/message';
import { Messages } from '../models/messages';

@Injectable({
  providedIn: 'root'
})
export class ApstorymqClientService {

  constructor(public httpClient: HttpClient) { }

  private _apiUrl!: string;
  private _client!: string;
  private _key!: string;

  async init(apiUrl: string, key: string, client: string) {
    this._apiUrl = apiUrl;
    this._key = key;
    this._client = client;
  }

  async createSubscription(topic: string) {   
    const url = `${this._apiUrl}message?key=${this._key}&client=${this._client}&topic=${topic}&pageSize=1`
    await this.httpClient.get(url).toPromise();
  }

  async publish(topic: string, messages: Message[]): Promise<Message[]> {
    const url = `${this._apiUrl}message?key=${this._key}&client=${this._client}&topic=${topic}`
    return await this.httpClient.post<Message[]>(url, messages).toPromise();
  }

  async subscribe(topic: string): Promise<Messages> {
    const url = `${this._apiUrl}message?key=${this._key}&client=${this._client}&topic=${topic}&pageSize=200`
    return await this.httpClient.get<Messages>(url).toPromise();
  }

  async commit(topic: string, messageId: number): Promise<Boolean> {
    const url = `${this._apiUrl}message?key=${this._key}&client=${this._client}&topic=${topic}`
    return await this.httpClient.delete<Boolean>(url).toPromise();
  }

  async commitMessageList(topic: string, messages: Message[]): Promise<Message[]> {
    const url = `${this._apiUrl}message?key=${this._key}&client=${this._client}&topic=${topic}`
    const options = {
      body: messages
    }
    return await this.httpClient.delete<Message[]>(url, options).toPromise();
  }

}
