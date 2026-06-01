/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ibms_ttrd_otc_trade_ext
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ibms_ttrd_otc_trade_ext
whenever sqlerror continue none;
drop table ${iol_schema}.ibms_ttrd_otc_trade_ext purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ibms_ttrd_otc_trade_ext(
    sysordid number(16,0) -- 主键
    ,h_textfield_03 varchar2(90) -- 文本3默认隐藏
    ,h_textfield_04 varchar2(90) -- 文本4默认隐藏
    ,h_textfield_01 varchar2(90) -- 文本1默认隐藏
    ,h_textfield_02 varchar2(90) -- 文本2默认隐藏
    ,s_textfield_01 varchar2(90) -- 文本1默认显示
    ,s_textfield_02 varchar2(90) -- 文本2默认显示
    ,s_textfield_03 varchar2(95) -- 文本3默认显示
    ,s_textfield_04 varchar2(90) -- 文本4默认显示
    ,h_numberfield_01 number(31,2) -- 数值1默认隐藏
    ,h_numberfield_02 number(31,2) -- 数值2默认隐藏
    ,h_numberfield_03 number(31,2) -- 数值3默认隐藏
    ,h_numberfield_04 number(31,2) -- 数值4默认隐藏
    ,s_numberfield_01 number(31,2) -- 数值1默认显示
    ,s_numberfield_02 number(31,2) -- 数值2默认显示
    ,s_numberfield_03 number(31,2) -- 数值3默认显示
    ,s_numberfield_04 number(31,2) -- 数值4默认显示
    ,h_datefield_01 varchar2(29) -- 日期1默认隐藏
    ,h_datefield_02 varchar2(29) -- 日期2默认隐藏
    ,h_datefield_03 varchar2(29) -- 日期3默认隐藏
    ,h_datefield_04 varchar2(29) -- 日期4默认隐藏
    ,s_datefield_01 varchar2(29) -- 日期1默认显示
    ,s_datefield_02 varchar2(29) -- 日期2默认显示
    ,s_datefield_03 varchar2(29) -- 日期3默认显示
    ,s_datefield_04 varchar2(29) -- 日期4默认显示
    ,h_combobox_01 varchar2(150) -- 下拉框1默认隐藏
    ,h_combobox_02 varchar2(150) -- 下拉框2默认隐藏
    ,h_combobox_03 varchar2(150) -- 下拉框3默认隐藏
    ,h_combobox_04 varchar2(150) -- 下拉框4默认隐藏
    ,s_combobox_01 varchar2(150) -- 下拉框1默认显示
    ,s_combobox_02 varchar2(150) -- 下拉框2默认显示
    ,s_combobox_03 varchar2(150) -- 下拉框3默认显示
    ,s_combobox_04 varchar2(150) -- 下拉框4默认显示
    ,h_textarea_01 varchar2(4000) -- 文本域1默认隐藏
    ,h_textarea_02 varchar2(4000) -- 文本域2默认隐藏
    ,s_textarea_01 varchar2(4000) -- 文本域1默认显示
    ,s_textarea_02 varchar2(4000) -- 文本域2默认显示
    ,h_dayrange_01 varchar2(750) -- 天数范围01
    ,h_dayrange_02 varchar2(750) -- 天数范围02
    ,h_dayrange_03 varchar2(750) -- 天数范围03
    ,h_dayrange_04 varchar2(750) -- 天数范围04
    ,h_dayrange_05 varchar2(750) -- 天数范围05
    ,h_hidden_01 varchar2(750) -- 隐藏01
    ,h_amount_01 number(31,6) -- 金额01
    ,h_amount_02 number(31,6) -- 金额02
    ,h_amount_03 number(31,6) -- 金额03
    ,h_amount_04 number(31,6) -- 金额04
    ,h_rate_01 number(31,2) -- 利率01
    ,h_rate_02 number(31,2) -- 利率02
    ,h_rate_03 number(31,2) -- 利率03
    ,h_rate_04 number(31,2) -- 利率04
    ,h_rate_05 number(31,2) -- 利率05
    ,h_rate_07_f4 number(31,8) -- 利率01_4位小数
    ,rx_bnd_ytm number(31,4) -- 
    ,is_quarter_redeem varchar2(150) -- 是否当季赎回
    ,redem_datefield varchar2(15) -- 预期赎回日期
    ,online_mark varchar2(15) -- 是否线上 码值：“是”、“否”
    ,is_linked_bond varchar2(15) -- 是否条线联动债券
    ,etl_dt date -- ETL处理日期
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 64k next 64k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.ibms_ttrd_otc_trade_ext to ${iml_schema};
grant select on ${iol_schema}.ibms_ttrd_otc_trade_ext to ${icl_schema};
grant select on ${iol_schema}.ibms_ttrd_otc_trade_ext to ${idl_schema};
grant select on ${iol_schema}.ibms_ttrd_otc_trade_ext to ${iel_schema};

-- comment
comment on table ${iol_schema}.ibms_ttrd_otc_trade_ext is '交易信息自定义扩展表';
comment on column ${iol_schema}.ibms_ttrd_otc_trade_ext.sysordid is '主键';
comment on column ${iol_schema}.ibms_ttrd_otc_trade_ext.h_textfield_03 is '文本3默认隐藏';
comment on column ${iol_schema}.ibms_ttrd_otc_trade_ext.h_textfield_04 is '文本4默认隐藏';
comment on column ${iol_schema}.ibms_ttrd_otc_trade_ext.h_textfield_01 is '文本1默认隐藏';
comment on column ${iol_schema}.ibms_ttrd_otc_trade_ext.h_textfield_02 is '文本2默认隐藏';
comment on column ${iol_schema}.ibms_ttrd_otc_trade_ext.s_textfield_01 is '文本1默认显示';
comment on column ${iol_schema}.ibms_ttrd_otc_trade_ext.s_textfield_02 is '文本2默认显示';
comment on column ${iol_schema}.ibms_ttrd_otc_trade_ext.s_textfield_03 is '文本3默认显示';
comment on column ${iol_schema}.ibms_ttrd_otc_trade_ext.s_textfield_04 is '文本4默认显示';
comment on column ${iol_schema}.ibms_ttrd_otc_trade_ext.h_numberfield_01 is '数值1默认隐藏';
comment on column ${iol_schema}.ibms_ttrd_otc_trade_ext.h_numberfield_02 is '数值2默认隐藏';
comment on column ${iol_schema}.ibms_ttrd_otc_trade_ext.h_numberfield_03 is '数值3默认隐藏';
comment on column ${iol_schema}.ibms_ttrd_otc_trade_ext.h_numberfield_04 is '数值4默认隐藏';
comment on column ${iol_schema}.ibms_ttrd_otc_trade_ext.s_numberfield_01 is '数值1默认显示';
comment on column ${iol_schema}.ibms_ttrd_otc_trade_ext.s_numberfield_02 is '数值2默认显示';
comment on column ${iol_schema}.ibms_ttrd_otc_trade_ext.s_numberfield_03 is '数值3默认显示';
comment on column ${iol_schema}.ibms_ttrd_otc_trade_ext.s_numberfield_04 is '数值4默认显示';
comment on column ${iol_schema}.ibms_ttrd_otc_trade_ext.h_datefield_01 is '日期1默认隐藏';
comment on column ${iol_schema}.ibms_ttrd_otc_trade_ext.h_datefield_02 is '日期2默认隐藏';
comment on column ${iol_schema}.ibms_ttrd_otc_trade_ext.h_datefield_03 is '日期3默认隐藏';
comment on column ${iol_schema}.ibms_ttrd_otc_trade_ext.h_datefield_04 is '日期4默认隐藏';
comment on column ${iol_schema}.ibms_ttrd_otc_trade_ext.s_datefield_01 is '日期1默认显示';
comment on column ${iol_schema}.ibms_ttrd_otc_trade_ext.s_datefield_02 is '日期2默认显示';
comment on column ${iol_schema}.ibms_ttrd_otc_trade_ext.s_datefield_03 is '日期3默认显示';
comment on column ${iol_schema}.ibms_ttrd_otc_trade_ext.s_datefield_04 is '日期4默认显示';
comment on column ${iol_schema}.ibms_ttrd_otc_trade_ext.h_combobox_01 is '下拉框1默认隐藏';
comment on column ${iol_schema}.ibms_ttrd_otc_trade_ext.h_combobox_02 is '下拉框2默认隐藏';
comment on column ${iol_schema}.ibms_ttrd_otc_trade_ext.h_combobox_03 is '下拉框3默认隐藏';
comment on column ${iol_schema}.ibms_ttrd_otc_trade_ext.h_combobox_04 is '下拉框4默认隐藏';
comment on column ${iol_schema}.ibms_ttrd_otc_trade_ext.s_combobox_01 is '下拉框1默认显示';
comment on column ${iol_schema}.ibms_ttrd_otc_trade_ext.s_combobox_02 is '下拉框2默认显示';
comment on column ${iol_schema}.ibms_ttrd_otc_trade_ext.s_combobox_03 is '下拉框3默认显示';
comment on column ${iol_schema}.ibms_ttrd_otc_trade_ext.s_combobox_04 is '下拉框4默认显示';
comment on column ${iol_schema}.ibms_ttrd_otc_trade_ext.h_textarea_01 is '文本域1默认隐藏';
comment on column ${iol_schema}.ibms_ttrd_otc_trade_ext.h_textarea_02 is '文本域2默认隐藏';
comment on column ${iol_schema}.ibms_ttrd_otc_trade_ext.s_textarea_01 is '文本域1默认显示';
comment on column ${iol_schema}.ibms_ttrd_otc_trade_ext.s_textarea_02 is '文本域2默认显示';
comment on column ${iol_schema}.ibms_ttrd_otc_trade_ext.h_dayrange_01 is '天数范围01';
comment on column ${iol_schema}.ibms_ttrd_otc_trade_ext.h_dayrange_02 is '天数范围02';
comment on column ${iol_schema}.ibms_ttrd_otc_trade_ext.h_dayrange_03 is '天数范围03';
comment on column ${iol_schema}.ibms_ttrd_otc_trade_ext.h_dayrange_04 is '天数范围04';
comment on column ${iol_schema}.ibms_ttrd_otc_trade_ext.h_dayrange_05 is '天数范围05';
comment on column ${iol_schema}.ibms_ttrd_otc_trade_ext.h_hidden_01 is '隐藏01';
comment on column ${iol_schema}.ibms_ttrd_otc_trade_ext.h_amount_01 is '金额01';
comment on column ${iol_schema}.ibms_ttrd_otc_trade_ext.h_amount_02 is '金额02';
comment on column ${iol_schema}.ibms_ttrd_otc_trade_ext.h_amount_03 is '金额03';
comment on column ${iol_schema}.ibms_ttrd_otc_trade_ext.h_amount_04 is '金额04';
comment on column ${iol_schema}.ibms_ttrd_otc_trade_ext.h_rate_01 is '利率01';
comment on column ${iol_schema}.ibms_ttrd_otc_trade_ext.h_rate_02 is '利率02';
comment on column ${iol_schema}.ibms_ttrd_otc_trade_ext.h_rate_03 is '利率03';
comment on column ${iol_schema}.ibms_ttrd_otc_trade_ext.h_rate_04 is '利率04';
comment on column ${iol_schema}.ibms_ttrd_otc_trade_ext.h_rate_05 is '利率05';
comment on column ${iol_schema}.ibms_ttrd_otc_trade_ext.h_rate_07_f4 is '利率01_4位小数';
comment on column ${iol_schema}.ibms_ttrd_otc_trade_ext.rx_bnd_ytm is '';
comment on column ${iol_schema}.ibms_ttrd_otc_trade_ext.is_quarter_redeem is '是否当季赎回';
comment on column ${iol_schema}.ibms_ttrd_otc_trade_ext.redem_datefield is '预期赎回日期';
comment on column ${iol_schema}.ibms_ttrd_otc_trade_ext.online_mark is '是否线上 码值：“是”、“否”';
comment on column ${iol_schema}.ibms_ttrd_otc_trade_ext.is_linked_bond is '是否条线联动债券';
comment on column ${iol_schema}.ibms_ttrd_otc_trade_ext.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.ibms_ttrd_otc_trade_ext.etl_timestamp is 'ETL处理时间戳';
