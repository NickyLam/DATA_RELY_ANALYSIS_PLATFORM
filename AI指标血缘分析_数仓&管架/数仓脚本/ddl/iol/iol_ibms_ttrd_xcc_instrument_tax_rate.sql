/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ibms_ttrd_xcc_instrument_tax_rate
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ibms_ttrd_xcc_instrument_tax_rate
whenever sqlerror continue none;
drop table ${iol_schema}.ibms_ttrd_xcc_instrument_tax_rate purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ibms_ttrd_xcc_instrument_tax_rate(
    rate_id number(16,0) -- 
    ,p_class varchar2(150) -- 
    ,tax_calc_type number(22,0) -- 
    ,tax_output_type number(22,0) -- 
    ,tax_rate_field varchar2(150) -- 
    ,tax_rate number(31,8) -- 
    ,p_type varchar2(45) -- 
    ,tax_item varchar2(30) -- 商品或应税服务名称利息收入(1000_0:地方政府债；1000_1：国债；1000_2：金融同业往来业务；1000_3：利息收入；1000_4：其他贷款服  务)；商品或应税服务名称买卖价差（2000_0：债券转让；2000_1：其他金融商品转让）
    ,tax_billreq number(22,0) -- 业务开票要求( 0：普通发票 1：专用发票 2：不开票 )
    ,tax_methodcal number(22,0) -- 计税方法0：一般计税方法 1：简易计税方法 2：零税率 3：免征 4：减征 5：即征即退
    ,updatetime varchar2(29) -- 
    ,userid varchar2(45) -- 
    ,tax_type_rate number(22,0) -- 征税类型 0 征税 1 免税 2 不征税
    ,status number(22,0) -- 状态 0 禁用 1 启用
    ,beg_date varchar2(15) -- 
    ,end_date varchar2(15) -- 
    ,start_dt date -- 开始时间
    ,end_dt date -- 结束时间
    ,id_mark varchar2(10) -- 增删标志
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(end_dt)(
     partition p_19000101 values (to_date('19000101','yyyymmdd')),
     partition p_20991231 values (to_date('20991231','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.ibms_ttrd_xcc_instrument_tax_rate to ${iml_schema};
grant select on ${iol_schema}.ibms_ttrd_xcc_instrument_tax_rate to ${icl_schema};
grant select on ${iol_schema}.ibms_ttrd_xcc_instrument_tax_rate to ${idl_schema};
grant select on ${iol_schema}.ibms_ttrd_xcc_instrument_tax_rate to ${iel_schema};

-- comment
comment on table ${iol_schema}.ibms_ttrd_xcc_instrument_tax_rate is '浮动金融工具相关信息表';
comment on column ${iol_schema}.ibms_ttrd_xcc_instrument_tax_rate.rate_id is '';
comment on column ${iol_schema}.ibms_ttrd_xcc_instrument_tax_rate.p_class is '';
comment on column ${iol_schema}.ibms_ttrd_xcc_instrument_tax_rate.tax_calc_type is '';
comment on column ${iol_schema}.ibms_ttrd_xcc_instrument_tax_rate.tax_output_type is '';
comment on column ${iol_schema}.ibms_ttrd_xcc_instrument_tax_rate.tax_rate_field is '';
comment on column ${iol_schema}.ibms_ttrd_xcc_instrument_tax_rate.tax_rate is '';
comment on column ${iol_schema}.ibms_ttrd_xcc_instrument_tax_rate.p_type is '';
comment on column ${iol_schema}.ibms_ttrd_xcc_instrument_tax_rate.tax_item is '商品或应税服务名称利息收入(1000_0:地方政府债；1000_1：国债；1000_2：金融同业往来业务；1000_3：利息收入；1000_4：其他贷款服  务)；商品或应税服务名称买卖价差（2000_0：债券转让；2000_1：其他金融商品转让）';
comment on column ${iol_schema}.ibms_ttrd_xcc_instrument_tax_rate.tax_billreq is '业务开票要求( 0：普通发票 1：专用发票 2：不开票 )';
comment on column ${iol_schema}.ibms_ttrd_xcc_instrument_tax_rate.tax_methodcal is '计税方法0：一般计税方法 1：简易计税方法 2：零税率 3：免征 4：减征 5：即征即退';
comment on column ${iol_schema}.ibms_ttrd_xcc_instrument_tax_rate.updatetime is '';
comment on column ${iol_schema}.ibms_ttrd_xcc_instrument_tax_rate.userid is '';
comment on column ${iol_schema}.ibms_ttrd_xcc_instrument_tax_rate.tax_type_rate is '征税类型 0 征税 1 免税 2 不征税';
comment on column ${iol_schema}.ibms_ttrd_xcc_instrument_tax_rate.status is '状态 0 禁用 1 启用';
comment on column ${iol_schema}.ibms_ttrd_xcc_instrument_tax_rate.beg_date is '';
comment on column ${iol_schema}.ibms_ttrd_xcc_instrument_tax_rate.end_date is '';
comment on column ${iol_schema}.ibms_ttrd_xcc_instrument_tax_rate.start_dt is '开始时间';
comment on column ${iol_schema}.ibms_ttrd_xcc_instrument_tax_rate.end_dt is '结束时间';
comment on column ${iol_schema}.ibms_ttrd_xcc_instrument_tax_rate.id_mark is '增删标志';
comment on column ${iol_schema}.ibms_ttrd_xcc_instrument_tax_rate.etl_timestamp is 'ETL处理时间戳';
