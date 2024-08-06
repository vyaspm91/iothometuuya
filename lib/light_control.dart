import 'package:flutter/material.dart';

class LightControl extends StatefulWidget {
  @override
  _LightControlState createState() => _LightControlState();
}

class _LightControlState extends State<LightControl> {
  bool _isOn = false;

  void _toggleLight() {
    setState(() {
      _isOn = !_isOn;

    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('Smart Light Control', style: TextStyle(fontSize: 24)),
        SizedBox(height: 20),
        Icon(
          _isOn ? Icons.lightbulb : Icons.lightbulb_outline,
          color: _isOn ? Colors.yellow : Colors.grey,
          size: 100,
        ),
        SizedBox(height: 20),
        ElevatedButton(
          onPressed: _toggleLight,
          child: Text(_isOn ? 'Turn Off' : 'Turn On'),
        ),
      ],
    );
  }
}
