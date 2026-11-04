import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:point_zero/main.dart';
import 'package:point_zero/widgets/pedido_bottom_sheet.dart';

void main() {
  Future<void> abrirApp(WidgetTester tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(390, 844);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.view.resetPhysicalSize);
    await tester.pumpWidget(const MyApp());
    await tester.pump(const Duration(seconds: 3));
    await tester.pumpAndSettle();
  }

  Future<void> abrirPerfil(WidgetTester tester) async {
    await abrirApp(tester);
    await tester.tap(find.text('Perfil'));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Editar datos'));
    await tester.pumpAndSettle();
  }

  testWidgets('Guarda el perfil y conserva la búsqueda y el pedido del menú', (
    tester,
  ) async {
    await abrirApp(tester);
    await tester.enterText(find.byType(TextField), 'enchiladas');
    await tester.pumpAndSettle();
    await tester.tap(find.text('Perfil'));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Editar datos'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextFormField).at(0), '  Ana López  ');
    await tester.enterText(find.byType(TextFormField).at(1), 'ana@example.com');
    await tester.enterText(find.byType(TextFormField).at(2), '9981234567');
    await tester.ensureVisible(find.text('Guardar cambios'));
    await tester.tap(find.text('Guardar cambios'));
    await tester.pumpAndSettle();
    expect(find.text('Ana López'), findsOneWidget);
    expect(find.text('ana@example.com'), findsOneWidget);
    await tester.tap(find.byTooltip('Editar datos'));
    await tester.pumpAndSettle();
    expect(find.widgetWithText(TextFormField, '9981234567'), findsOneWidget);
    await tester.tap(find.text('Cancelar'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Menú'));
    await tester.pumpAndSettle();
    expect(find.text('enchiladas'), findsOneWidget);
    expect(find.text('1 PRODUCTOS'), findsOneWidget);
    await tester.tap(find.byTooltip('Ver pedido'));
    await tester.pumpAndSettle();
    expect(find.text('Tu pedido'), findsOneWidget);
    expect(find.text('Enchiladas verdes'), findsWidgets);
    expect(find.textContaining('220'), findsWidgets);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Valida los campos y cancelar descarta las ediciones', (
    tester,
  ) async {
    await abrirPerfil(tester);
    await tester.enterText(find.byType(TextFormField).at(0), 'A');
    await tester.enterText(
      find.byType(TextFormField).at(1),
      'correo-sin-arroba',
    );
    await tester.enterText(find.byType(TextFormField).at(2), '123');
    await tester.ensureVisible(find.text('Guardar cambios'));
    await tester.tap(find.text('Guardar cambios'));
    await tester.pumpAndSettle();
    expect(
      find.text('Escribe un nombre de al menos 2 caracteres.'),
      findsOneWidget,
    );
    expect(find.text('Revisa el correo electrónico.'), findsOneWidget);
    expect(find.text('Escribe los 10 dígitos del teléfono.'), findsOneWidget);
    await tester.ensureVisible(find.text('Cancelar'));
    await tester.tap(find.text('Cancelar'));
    await tester.pumpAndSettle();
    expect(find.text('Tu perfil'), findsOneWidget);
    expect(find.text('A'), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('El perfil comparte el pedido del menú y conserva favoritos', (
    tester,
  ) async {
    await abrirApp(tester);
    await tester.tap(find.text('Perfil'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Mis pedidos'));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Agregar uno'));
    await tester.pumpAndSettle();
    expect(
      find.descendant(
        of: find.byType(PedidoBottomSheet),
        matching: find.text('\$330'),
      ),
      findsOneWidget,
    );
    Navigator.of(tester.element(find.text('Tu pedido'))).pop();
    await tester.pumpAndSettle();
    await tester.tap(find.text('Menú'));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Ver pedido'));
    await tester.pumpAndSettle();
    expect(
      find.descendant(
        of: find.byType(PedidoBottomSheet),
        matching: find.text('\$330'),
      ),
      findsOneWidget,
    );
    Navigator.of(tester.element(find.text('Tu pedido'))).pop();
    await tester.pumpAndSettle();
    await tester.tap(find.text('Perfil'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Mis favoritos'));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Guardar Tacos de pollo'));
    await tester.pumpAndSettle();
    await tester.pageBack();
    await tester.pumpAndSettle();
    await tester.tap(find.text('Mis favoritos'));
    await tester.pumpAndSettle();
    expect(find.byTooltip('Quitar Tacos de pollo'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Conserva la dirección y la preferencia de pago al volver', (
    tester,
  ) async {
    await abrirApp(tester);
    await tester.tap(find.text('Perfil'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Direcciones guardadas'));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byType(TextFormField),
      'Calle 10, número 25, Centro, Cancún',
    );
    await tester.tap(find.text('Guardar dirección'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Direcciones guardadas'));
    await tester.pumpAndSettle();
    expect(
      find.widgetWithText(TextFormField, 'Calle 10, número 25, Centro, Cancún'),
      findsOneWidget,
    );
    await tester.pageBack();
    await tester.pumpAndSettle();
    await tester.tap(find.text('Métodos de pago'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Tarjeta al recibir'));
    await tester.tap(find.text('Guardar preferencia'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Métodos de pago'));
    await tester.pumpAndSettle();
    final metodo = tester.widget<ListTile>(
      find.widgetWithText(ListTile, 'Tarjeta al recibir'),
    );
    expect(metodo.selected, isTrue);
    expect(tester.takeException(), isNull);
  });

  testWidgets('El splash abre el menú con acceso al perfil', (tester) async {
    await tester.pumpWidget(const MyApp());
    expect(find.text('Point-Zero'), findsOneWidget);
    expect(find.text('Perfil'), findsNothing);
    await tester.pump(const Duration(seconds: 3));
    await tester.pumpAndSettle();
    expect(find.byTooltip('Ver pedido'), findsOneWidget);
    await tester.tap(find.text('Perfil'));
    await tester.pumpAndSettle();
    expect(find.text('POINT ZERO'), findsOneWidget);
    expect(find.text('Mis pedidos'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
