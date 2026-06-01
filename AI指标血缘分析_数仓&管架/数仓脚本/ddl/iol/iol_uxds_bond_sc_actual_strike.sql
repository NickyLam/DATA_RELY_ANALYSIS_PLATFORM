/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol uxds_bond_sc_actual_strike
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.uxds_bond_sc_actual_strike
whenever sqlerror continue none;
drop table ${iol_schema}.uxds_bond_sc_actual_strike purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.uxds_bond_sc_actual_strike(
    seq number(20,0) -- 记录唯一标识
    ,ctime date -- 记录创建日期
    ,mtime date -- 记录修改日期
    ,rtime date -- 记录通讯到用户端日期
    ,bond_id varchar2(96) -- 债券id
    ,record_sd date -- 登记起始日
    ,record_ed date -- 登记截止日
    ,strike_date date -- 行权日
    ,clause_type_code varchar2(36) -- 条款类型编码
    ,clause_type varchar2(300) -- 条款类型
    ,strike_price number(18,4) -- 行权价
    ,strike_num number(14,0) -- 行权数量
    ,capital_to_account_date date -- 资金到账日
    ,introduction varchar2(600) -- 说明
    ,margin_after_strike number(18,4) -- 行权后利差
    ,resale_code varchar2(120) -- 回售代码
    ,resale_name varchar2(300) -- 回售简称
    ,strike_result_ad date -- 行权结果公告日
    ,notice_date date -- 提示公告日
    ,redemp_stop_td_date date -- 赎回停止交易日
    ,isvalid number(1,0) -- 是否有效
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
grant select on ${iol_schema}.uxds_bond_sc_actual_strike to ${iml_schema};
grant select on ${iol_schema}.uxds_bond_sc_actual_strike to ${icl_schema};
grant select on ${iol_schema}.uxds_bond_sc_actual_strike to ${idl_schema};
grant select on ${iol_schema}.uxds_bond_sc_actual_strike to ${iel_schema};

-- comment
comment on table ${iol_schema}.uxds_bond_sc_actual_strike is '中国债券特殊条款实际行权';
comment on column ${iol_schema}.uxds_bond_sc_actual_strike.seq is '记录唯一标识';
comment on column ${iol_schema}.uxds_bond_sc_actual_strike.ctime is '记录创建日期';
comment on column ${iol_schema}.uxds_bond_sc_actual_strike.mtime is '记录修改日期';
comment on column ${iol_schema}.uxds_bond_sc_actual_strike.rtime is '记录通讯到用户端日期';
comment on column ${iol_schema}.uxds_bond_sc_actual_strike.bond_id is '债券id';
comment on column ${iol_schema}.uxds_bond_sc_actual_strike.record_sd is '登记起始日';
comment on column ${iol_schema}.uxds_bond_sc_actual_strike.record_ed is '登记截止日';
comment on column ${iol_schema}.uxds_bond_sc_actual_strike.strike_date is '行权日';
comment on column ${iol_schema}.uxds_bond_sc_actual_strike.clause_type_code is '条款类型编码';
comment on column ${iol_schema}.uxds_bond_sc_actual_strike.clause_type is '条款类型';
comment on column ${iol_schema}.uxds_bond_sc_actual_strike.strike_price is '行权价';
comment on column ${iol_schema}.uxds_bond_sc_actual_strike.strike_num is '行权数量';
comment on column ${iol_schema}.uxds_bond_sc_actual_strike.capital_to_account_date is '资金到账日';
comment on column ${iol_schema}.uxds_bond_sc_actual_strike.introduction is '说明';
comment on column ${iol_schema}.uxds_bond_sc_actual_strike.margin_after_strike is '行权后利差';
comment on column ${iol_schema}.uxds_bond_sc_actual_strike.resale_code is '回售代码';
comment on column ${iol_schema}.uxds_bond_sc_actual_strike.resale_name is '回售简称';
comment on column ${iol_schema}.uxds_bond_sc_actual_strike.strike_result_ad is '行权结果公告日';
comment on column ${iol_schema}.uxds_bond_sc_actual_strike.notice_date is '提示公告日';
comment on column ${iol_schema}.uxds_bond_sc_actual_strike.redemp_stop_td_date is '赎回停止交易日';
comment on column ${iol_schema}.uxds_bond_sc_actual_strike.isvalid is '是否有效';
comment on column ${iol_schema}.uxds_bond_sc_actual_strike.start_dt is '开始时间';
comment on column ${iol_schema}.uxds_bond_sc_actual_strike.end_dt is '结束时间';
comment on column ${iol_schema}.uxds_bond_sc_actual_strike.id_mark is '增删标志';
comment on column ${iol_schema}.uxds_bond_sc_actual_strike.etl_timestamp is 'ETL处理时间戳';
