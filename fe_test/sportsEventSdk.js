class SportsEventSdk {
  constructor(apiBaseUrl) {
    this.apiBaseUrl = apiBaseUrl;
  }

  formatDate(isoDateString) {
    const datePart = isoDateString.slice(0, 10);
    const timePart = isoDateString.slice(11, 19);
    return `${datePart} ${timePart}`;
  }

  async createEvent(title, timeFrom, timeTo, comment) {
    const requestBody = {
      title: title,
      timeFrom: this.formatDate(timeFrom),
      timeTo: this.formatDate(timeTo),
      ownerId: "xxxxx_owner_xxxx_id",
      comment: comment,
      eventType: 1,
      sportEventIdList: [1, 2],
    };

    const response = await fetch(`${this.apiBaseUrl}/sportsevent/v1/api/event`, {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
      },
      body: JSON.stringify(requestBody),
    });

    if (response.ok) {
      return await response.json();
    } else {
      throw new Error("Error creating event: " + response.statusText);
    }
  }
}

export default SportsEventSdk;

