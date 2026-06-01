/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ibms_ttrd_instrument_extend
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ibms_ttrd_instrument_extend
whenever sqlerror continue none;
drop table ${iol_schema}.ibms_ttrd_instrument_extend purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ibms_ttrd_instrument_extend(
    i_code varchar2(48) -- 金融工具代码
    ,a_type varchar2(30) -- 资产类型
    ,m_type varchar2(30) -- 市场类型
    ,extend_type varchar2(3) -- 扩展类型【01：本金序列；02：利率/利差序列；03：债券发行量；04：含权信息】
    ,beg_date varchar2(15) -- 生效日期【当扩展类型为04时，表示理论行权日期】
    ,end_date varchar2(15) -- 失效日期【当扩展类型为04时，表示理论行权结束日期，且只对美式有效】
    ,rate_multi number(22,0) -- 利率乘数【当扩展类型为02时有效】
    ,volume number(37,12) -- 发生额，根据extend_type类型不同，其含义不同【01：本金；02：利率/利差；03：债券发行量；04：补偿利率】
    ,oe_type varchar2(3) -- 含权类型【01：赎回；02：回售】
    ,oe_option_type varchar2(3) -- 选择权类型【01：欧式；02：美式；目前国内只有欧式】
    ,oe_finish_date varchar2(15) -- 实际行权日期
    ,update_user varchar2(150) -- 更新人
    ,update_time varchar2(35) -- 更新时间
    ,account_user varchar2(45) -- 复核人
    ,account_time varchar2(30) -- 复核时间
    ,strike_price number(31,6) -- 行权价格
    ,pipe_id number(22,0) -- 
    ,imp_date varchar2(15) -- 
    ,start_date varchar2(15) -- 起息日
    ,mtr_date varchar2(15) -- 到期日
    ,mtr_date_conv varchar2(30) -- 到期日调整规则
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
grant select on ${iol_schema}.ibms_ttrd_instrument_extend to ${iml_schema};
grant select on ${iol_schema}.ibms_ttrd_instrument_extend to ${icl_schema};
grant select on ${iol_schema}.ibms_ttrd_instrument_extend to ${idl_schema};
grant select on ${iol_schema}.ibms_ttrd_instrument_extend to ${iel_schema};

-- comment
comment on table ${iol_schema}.ibms_ttrd_instrument_extend is '';
comment on column ${iol_schema}.ibms_ttrd_instrument_extend.i_code is '金融工具代码';
comment on column ${iol_schema}.ibms_ttrd_instrument_extend.a_type is '资产类型';
comment on column ${iol_schema}.ibms_ttrd_instrument_extend.m_type is '市场类型';
comment on column ${iol_schema}.ibms_ttrd_instrument_extend.extend_type is '扩展类型【01：本金序列；02：利率/利差序列；03：债券发行量；04：含权信息】';
comment on column ${iol_schema}.ibms_ttrd_instrument_extend.beg_date is '生效日期【当扩展类型为04时，表示理论行权日期】';
comment on column ${iol_schema}.ibms_ttrd_instrument_extend.end_date is '失效日期【当扩展类型为04时，表示理论行权结束日期，且只对美式有效】';
comment on column ${iol_schema}.ibms_ttrd_instrument_extend.rate_multi is '利率乘数【当扩展类型为02时有效】';
comment on column ${iol_schema}.ibms_ttrd_instrument_extend.volume is '发生额，根据extend_type类型不同，其含义不同【01：本金；02：利率/利差；03：债券发行量；04：补偿利率】';
comment on column ${iol_schema}.ibms_ttrd_instrument_extend.oe_type is '含权类型【01：赎回；02：回售】';
comment on column ${iol_schema}.ibms_ttrd_instrument_extend.oe_option_type is '选择权类型【01：欧式；02：美式；目前国内只有欧式】';
comment on column ${iol_schema}.ibms_ttrd_instrument_extend.oe_finish_date is '实际行权日期';
comment on column ${iol_schema}.ibms_ttrd_instrument_extend.update_user is '更新人';
comment on column ${iol_schema}.ibms_ttrd_instrument_extend.update_time is '更新时间';
comment on column ${iol_schema}.ibms_ttrd_instrument_extend.account_user is '复核人';
comment on column ${iol_schema}.ibms_ttrd_instrument_extend.account_time is '复核时间';
comment on column ${iol_schema}.ibms_ttrd_instrument_extend.strike_price is '行权价格';
comment on column ${iol_schema}.ibms_ttrd_instrument_extend.pipe_id is '';
comment on column ${iol_schema}.ibms_ttrd_instrument_extend.imp_date is '';
comment on column ${iol_schema}.ibms_ttrd_instrument_extend.start_date is '起息日';
comment on column ${iol_schema}.ibms_ttrd_instrument_extend.mtr_date is '到期日';
comment on column ${iol_schema}.ibms_ttrd_instrument_extend.mtr_date_conv is '到期日调整规则';
comment on column ${iol_schema}.ibms_ttrd_instrument_extend.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.ibms_ttrd_instrument_extend.etl_timestamp is 'ETL处理时间戳';
