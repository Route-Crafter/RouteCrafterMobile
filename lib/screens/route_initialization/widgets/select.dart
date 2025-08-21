import 'package:flutter/material.dart';
import 'package:routes_mobile/screens/app_dimens.dart';

class Select<T> extends StatelessWidget {
  final Function(T) onTap;
  final String defaultValue;
  final List<T> items;
  final T? selected;
  final String Function(T) getTextBySelected;
  final bool isActive;
  final String disabledMessage;
  final double width;
  final bool Function(T, T?) areTheSame;
  final Function()? addNew;
  const Select({
    super.key,
    required this.onTap,
    required this.defaultValue,
    required this.items,
    required this.selected,
    required this.getTextBySelected,
    required this.isActive,
    required this.disabledMessage,
    required this.width,
    required this.areTheSame,
    this.addNew
  });

  @override
  Widget build(BuildContext context) {
    final popMenuHeight = AppDimens.heightPercentage(0.04, context);
    return GestureDetector(
      onTap: isActive? ()async{
        final RenderBox button = context.findRenderObject() as RenderBox;
        final RenderBox overlay =
            Overlay.of(context).context.findRenderObject() as RenderBox;

        // Calcula posición del menú
        final RelativeRect position = RelativeRect.fromRect(
          Rect.fromPoints(
            button.localToGlobal(Offset(0, popMenuHeight + 10), ancestor: overlay),
            button.localToGlobal(
              button.size.bottomRight(Offset(0, popMenuHeight + 10)),
              ancestor: overlay
            )
          ),
          Offset.zero & overlay.size,
        );
        await showMenu(
          context: context,
          position: position,
          menuPadding: EdgeInsets.zero,
          color: Theme.of(context).scaffoldBackgroundColor,
          items: [
            ...items.map(
              (c) => PopupMenuItem(
                height: 0,
                padding: EdgeInsets.zero,
                onTap: () => onTap(c),
                child: Align(
                  alignment: Alignment.center,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(
                        5
                      ),
                      color:  areTheSame(c, selected)?
                        Theme.of(context).primaryColor:
                        Theme.of(context).dialogBackgroundColor
                    ),
                    //width: double.infinity,
                    width: width * 1,
                    padding: const EdgeInsets.symmetric(
                      vertical: 8
                    ),
                    child: Center(
                      child: Text(
                        getTextBySelected(c),
                        style: TextStyle(
                          color: areTheSame(c, selected)?
                            Colors.white:
                            Colors.black87
                        ),
                      ),
                    ),
                  ),
                )
              )
            ),
            if(addNew != null)
              PopupMenuItem(
                onTap: addNew,
                child: SizedBox(
                  width: width,
                  child: const Center(
                    child: Text(
                      'Añadir'
                    )
                  )
                )
              )
          ]
        );
      } : null,
      child: Container(
        width: width,
        height: popMenuHeight,
        padding: const EdgeInsets.symmetric(
          horizontal: 20
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Theme.of(context).secondaryHeaderColor
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if(isActive)
              ...[
                if(selected != null)
                  SizedBox(
                    width: width * 0.6,
                    child: Text(
                      getTextBySelected(selected as T),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis
                    )
                  )
                else
                  Text(defaultValue)
              ]
            else
              Text(disabledMessage),
            const SizedBox(width: 10),
            Icon(
              Icons.arrow_drop_down_outlined,
              color: isActive?
                Theme.of(context).iconTheme.color:
                Theme.of(context).primaryColor.withOpacity(0.6)
            )
          ]
        )
      )
    );
  }
}