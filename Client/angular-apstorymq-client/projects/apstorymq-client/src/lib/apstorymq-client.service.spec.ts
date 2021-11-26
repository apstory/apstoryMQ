import { TestBed } from '@angular/core/testing';

import { ApstorymqClientService } from './apstorymq-client.service';

describe('ApstorymqClientService', () => {
  let service: ApstorymqClientService;

  beforeEach(() => {
    TestBed.configureTestingModule({});
    service = TestBed.inject(ApstorymqClientService);
  });

  it('should be created', () => {
    expect(service).toBeTruthy();
  });
});
