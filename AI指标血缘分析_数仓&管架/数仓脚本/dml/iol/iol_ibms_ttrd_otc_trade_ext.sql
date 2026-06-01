/*
Purpose:    偏源模型层-全量流水脚本，清空目标表，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ibms_ttrd_otc_trade_ext
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建脚本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 8;
alter session force parallel dml parallel 8;
-- alter session force parallel ddl parallel 8;

-- 2.1 create table for exchage and add partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ibms_ttrd_otc_trade_ext_ex purge;
alter table ${iol_schema}.ibms_ttrd_otc_trade_ext add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table
whenever sqlerror exit sql.sqlcode;
truncate table ${iol_schema}.ibms_ttrd_otc_trade_ext;

-- 2.3 insert data to ex table
create table ${iol_schema}.ibms_ttrd_otc_trade_ext_ex nologging
compress
as
select * from ${iol_schema}.ibms_ttrd_otc_trade_ext where 0=1;

insert /*+ append */ into ${iol_schema}.ibms_ttrd_otc_trade_ext_ex(
    sysordid -- 主键
    ,h_textfield_03 -- 文本3默认隐藏
    ,h_textfield_04 -- 文本4默认隐藏
    ,h_textfield_01 -- 文本1默认隐藏
    ,h_textfield_02 -- 文本2默认隐藏
    ,s_textfield_01 -- 文本1默认显示
    ,s_textfield_02 -- 文本2默认显示
    ,s_textfield_03 -- 文本3默认显示
    ,s_textfield_04 -- 文本4默认显示
    ,h_numberfield_01 -- 数值1默认隐藏
    ,h_numberfield_02 -- 数值2默认隐藏
    ,h_numberfield_03 -- 数值3默认隐藏
    ,h_numberfield_04 -- 数值4默认隐藏
    ,s_numberfield_01 -- 数值1默认显示
    ,s_numberfield_02 -- 数值2默认显示
    ,s_numberfield_03 -- 数值3默认显示
    ,s_numberfield_04 -- 数值4默认显示
    ,h_datefield_01 -- 日期1默认隐藏
    ,h_datefield_02 -- 日期2默认隐藏
    ,h_datefield_03 -- 日期3默认隐藏
    ,h_datefield_04 -- 日期4默认隐藏
    ,s_datefield_01 -- 日期1默认显示
    ,s_datefield_02 -- 日期2默认显示
    ,s_datefield_03 -- 日期3默认显示
    ,s_datefield_04 -- 日期4默认显示
    ,h_combobox_01 -- 下拉框1默认隐藏
    ,h_combobox_02 -- 下拉框2默认隐藏
    ,h_combobox_03 -- 下拉框3默认隐藏
    ,h_combobox_04 -- 下拉框4默认隐藏
    ,s_combobox_01 -- 下拉框1默认显示
    ,s_combobox_02 -- 下拉框2默认显示
    ,s_combobox_03 -- 下拉框3默认显示
    ,s_combobox_04 -- 下拉框4默认显示
    ,h_textarea_01 -- 文本域1默认隐藏
    ,h_textarea_02 -- 文本域2默认隐藏
    ,s_textarea_01 -- 文本域1默认显示
    ,s_textarea_02 -- 文本域2默认显示
    ,h_dayrange_01 -- 天数范围01
    ,h_dayrange_02 -- 天数范围02
    ,h_dayrange_03 -- 天数范围03
    ,h_dayrange_04 -- 天数范围04
    ,h_dayrange_05 -- 天数范围05
    ,h_hidden_01 -- 隐藏01
    ,h_amount_01 -- 金额01
    ,h_amount_02 -- 金额02
    ,h_amount_03 -- 金额03
    ,h_amount_04 -- 金额04
    ,h_rate_01 -- 利率01
    ,h_rate_02 -- 利率02
    ,h_rate_03 -- 利率03
    ,h_rate_04 -- 利率04
    ,h_rate_05 -- 利率05
    ,h_rate_07_f4 -- 利率01_4位小数
    ,rx_bnd_ytm -- 
    ,is_quarter_redeem -- 是否当季赎回
    ,redem_datefield -- 预期赎回日期
    ,online_mark -- 是否线上 码值：“是”、“否”
    ,is_linked_bond -- 是否条线联动债券
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    sysordid -- 主键
    ,h_textfield_03 -- 文本3默认隐藏
    ,h_textfield_04 -- 文本4默认隐藏
    ,h_textfield_01 -- 文本1默认隐藏
    ,h_textfield_02 -- 文本2默认隐藏
    ,s_textfield_01 -- 文本1默认显示
    ,s_textfield_02 -- 文本2默认显示
    ,s_textfield_03 -- 文本3默认显示
    ,s_textfield_04 -- 文本4默认显示
    ,h_numberfield_01 -- 数值1默认隐藏
    ,h_numberfield_02 -- 数值2默认隐藏
    ,h_numberfield_03 -- 数值3默认隐藏
    ,h_numberfield_04 -- 数值4默认隐藏
    ,s_numberfield_01 -- 数值1默认显示
    ,s_numberfield_02 -- 数值2默认显示
    ,s_numberfield_03 -- 数值3默认显示
    ,s_numberfield_04 -- 数值4默认显示
    ,h_datefield_01 -- 日期1默认隐藏
    ,h_datefield_02 -- 日期2默认隐藏
    ,h_datefield_03 -- 日期3默认隐藏
    ,h_datefield_04 -- 日期4默认隐藏
    ,s_datefield_01 -- 日期1默认显示
    ,s_datefield_02 -- 日期2默认显示
    ,s_datefield_03 -- 日期3默认显示
    ,s_datefield_04 -- 日期4默认显示
    ,h_combobox_01 -- 下拉框1默认隐藏
    ,h_combobox_02 -- 下拉框2默认隐藏
    ,h_combobox_03 -- 下拉框3默认隐藏
    ,h_combobox_04 -- 下拉框4默认隐藏
    ,s_combobox_01 -- 下拉框1默认显示
    ,s_combobox_02 -- 下拉框2默认显示
    ,s_combobox_03 -- 下拉框3默认显示
    ,s_combobox_04 -- 下拉框4默认显示
    ,h_textarea_01 -- 文本域1默认隐藏
    ,h_textarea_02 -- 文本域2默认隐藏
    ,s_textarea_01 -- 文本域1默认显示
    ,s_textarea_02 -- 文本域2默认显示
    ,h_dayrange_01 -- 天数范围01
    ,h_dayrange_02 -- 天数范围02
    ,h_dayrange_03 -- 天数范围03
    ,h_dayrange_04 -- 天数范围04
    ,h_dayrange_05 -- 天数范围05
    ,h_hidden_01 -- 隐藏01
    ,h_amount_01 -- 金额01
    ,h_amount_02 -- 金额02
    ,h_amount_03 -- 金额03
    ,h_amount_04 -- 金额04
    ,h_rate_01 -- 利率01
    ,h_rate_02 -- 利率02
    ,h_rate_03 -- 利率03
    ,h_rate_04 -- 利率04
    ,h_rate_05 -- 利率05
    ,h_rate_07_f4 -- 利率01_4位小数
    ,rx_bnd_ytm -- 
    ,is_quarter_redeem -- 是否当季赎回
    ,redem_datefield -- 预期赎回日期
    ,online_mark -- 是否线上 码值：“是”、“否”
    ,is_linked_bond -- 是否条线联动债券
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.ibms_ttrd_otc_trade_ext
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.ibms_ttrd_otc_trade_ext exchange partition p_${batch_date} with table ${iol_schema}.ibms_ttrd_otc_trade_ext_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ibms_ttrd_otc_trade_ext to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.ibms_ttrd_otc_trade_ext_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ibms_ttrd_otc_trade_ext',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);