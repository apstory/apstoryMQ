import { TestBed, inject } from '@angular/core/testing';

import { ApstoryMQClientService } from './apstory-mqclient.service';

describe('ApstoryMQClientService', () => {
  beforeEach(() => {
    TestBed.configureTestingModule({
      providers: [ApstoryMQClientService]
    });
  });

  it('should be created', inject([ApstoryMQClientService], (service: ApstoryMQClientService) => {
    expect(service).toBeTruthy();
  }));
});
