import 'package:flutter/material.dart';

class Service {
  final String name;
  final String imageUrl;

  Service(this.name, this.imageUrl);
}

class SelectService extends StatefulWidget {
  const SelectService({super.key});

  @override
  State<SelectService> createState() => _SelectServiceState();
}

class _SelectServiceState extends State<SelectService> {
  // Color scheme
  static const Color darkBlue = Color(0xFF304D6D);
  static const Color lightBlue = Color(0xFF63ADF2);

  String? selectedService;

  List<Service> services = [
    // Repairs
    Service(
      'Electrician',
      'https://img.icons8.com/external-wanicon-flat-wanicon/2x/external-multimeter-car-service-wanicon-flat-wanicon.png',
    ),
    Service(
      'Plumber',
      'https://img.icons8.com/external-vitaliy-gorbachev-flat-vitaly-gorbachev/2x/external-plumber-labour-day-vitaliy-gorbachev-flat-vitaly-gorbachev.png',
    ),
    Service('Carpenter', 'https://img.icons8.com/fluency/2x/drill.png'),
    Service(
      'AC Repair',
      'https://img.icons8.com/?size=100&id=Jskg4-JWkjF4&format=png&color=000000',
    ),
    Service(
      'Washing Machine Repair',
      'https://img.icons8.com/?size=100&id=Jvd285hxXqK6&format=png&color=000000',
    ),
    Service(
      'Refrigerator Repair',
      'https://img.icons8.com/?size=100&id=56605&format=png&color=000000',
    ),
    Service(
      'RO Water Purifier Repair',
      'https://img.icons8.com/?size=100&id=WPAThkXXlAN9&format=png&color=000000',
    ),
    Service(
      'Microwave Repair',
      'https://img.icons8.com/?size=100&id=66304&format=png&color=000000',
    ),
    Service(
      'Geyser Repair',
      'https://img.icons8.com/?size=100&id=65540&format=png&color=000000',
    ),
    Service(
      'Chimney & Hob Repair',
      'https://img.icons8.com/?size=100&id=zY1O74QugicA&format=png&color=000000',
    ),

    // Cleaning and Pest Control
    Service(
      'Home Deep Cleaning',
      'https://img.icons8.com/external-vitaliy-gorbachev-flat-vitaly-gorbachev/2x/external-cleaning-labour-day-vitaliy-gorbachev-flat-vitaly-gorbachev.png',
    ),
    Service(
      'Pest Control',
      'https://img.icons8.com/?size=100&id=0iDzTSlNteTH&format=png&color=000000',
    ),
    Service(
      'Bathroom Cleaning',
      'https://img.icons8.com/external-flaticons-flat-flat-icons/2x/external-bathroom-cleaning-flaticons-flat-flat-icons.png',
    ),
    Service(
      'Kitchen Cleaning',
      'https://img.icons8.com/external-flaticons-flat-flat-icons/2x/external-kitchen-cleaning-flaticons-flat-flat-icons.png',
    ),
    Service(
      'Carpet Cleaning',
      'https://img.icons8.com/?size=100&id=s36AxpVEwPRt&format=png&color=000000',
    ),
    Service(
      'Car Cleaning',
      'https://img.icons8.com/?size=100&id=tmJ81kcHHY3d&format=png&color=000000',
    ),

    // Home Projects
    Service(
      'Home Painters',
      'https://img.icons8.com/external-itim2101-flat-itim2101/2x/external-painter-male-occupation-avatar-itim2101-flat-itim2101.png',
    ),
    Service(
      'Packers & Movers',
      'https://img.icons8.com/?size=100&id=R6SgTreFdP9v&format=png&color=000000',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: darkBlue),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Select Service',
          style: TextStyle(
            color: darkBlue,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            Text(
              'Which service\ndo you need?',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: darkBlue,
                height: 1.2,
              ),
            ),
            SizedBox(height: 32),

            // Services Grid
            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 1.1,
                ),
                itemCount: services.length,
                itemBuilder: (context, index) {
                  final service = services[index];
                  final isSelected = selectedService == service.name;

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedService = service.name;
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isSelected ? lightBlue : Colors.transparent,
                          width: 3,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.08),
                            blurRadius: 8,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Service Icon/Image
                          Container(
                            width: 80,
                            height: 80,
                            padding: EdgeInsets.all(12),
                            child: Image.network(
                              service.imageUrl,
                              fit: BoxFit.contain,
                              errorBuilder: (context, error, stackTrace) {
                                return Icon(
                                  Icons.work,
                                  size: 40,
                                  color: lightBlue,
                                );
                              },
                            ),
                          ),
                          SizedBox(height: 12),

                          // Service Name
                          Text(
                            service.name,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: darkBlue,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            // Continue Button
            if (selectedService != null) ...[
              SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // You can navigate to the next page here
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: lightBlue,
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Continue with $selectedService',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(width: 8),
                      Container(
                        padding: EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.arrow_forward,
                          color: Colors.white,
                          size: 18,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
