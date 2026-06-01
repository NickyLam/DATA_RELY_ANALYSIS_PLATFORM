/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ctms_tbs_v_security_pymn_schd
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ctms_tbs_v_security_pymn_schd
whenever sqlerror continue none;
drop table ${iol_schema}.ctms_tbs_v_security_pymn_schd purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ctms_tbs_v_security_pymn_schd(
    security_code varchar2(24) -- 债券代码
    ,seq number(5,0) -- 付息次序
    ,payment_date varchar2(12) -- 付息日期
    ,call_date varchar2(12) -- 发行人赎回日期
    ,put_date varchar2(12) -- 投资人回售日期
    ,coupon_amt number(18,10) -- 付息金额
    ,back_amt number(17,9) -- 还本金额
    ,last_amt number(17,9) -- 剩余本金额
    ,modify_date date -- 修改时间
    ,call_price number(13,10) -- 发行人赎回价格
    ,put_price number(13,10) -- 投资人回售价格
    ,convert_date varchar2(12) -- 转换日期
    ,convert_security_code varchar2(24) -- 转换债券代码
    ,back_announce_date varchar2(12) -- 还本公告日期
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
grant select on ${iol_schema}.ctms_tbs_v_security_pymn_schd to ${iml_schema};
grant select on ${iol_schema}.ctms_tbs_v_security_pymn_schd to ${icl_schema};
grant select on ${iol_schema}.ctms_tbs_v_security_pymn_schd to ${idl_schema};
grant select on ${iol_schema}.ctms_tbs_v_security_pymn_schd to ${iel_schema};

-- comment
comment on table ${iol_schema}.ctms_tbs_v_security_pymn_schd is '还本付息日程(基本资料)';
comment on column ${iol_schema}.ctms_tbs_v_security_pymn_schd.security_code is '债券代码';
comment on column ${iol_schema}.ctms_tbs_v_security_pymn_schd.seq is '付息次序';
comment on column ${iol_schema}.ctms_tbs_v_security_pymn_schd.payment_date is '付息日期';
comment on column ${iol_schema}.ctms_tbs_v_security_pymn_schd.call_date is '发行人赎回日期';
comment on column ${iol_schema}.ctms_tbs_v_security_pymn_schd.put_date is '投资人回售日期';
comment on column ${iol_schema}.ctms_tbs_v_security_pymn_schd.coupon_amt is '付息金额';
comment on column ${iol_schema}.ctms_tbs_v_security_pymn_schd.back_amt is '还本金额';
comment on column ${iol_schema}.ctms_tbs_v_security_pymn_schd.last_amt is '剩余本金额';
comment on column ${iol_schema}.ctms_tbs_v_security_pymn_schd.modify_date is '修改时间';
comment on column ${iol_schema}.ctms_tbs_v_security_pymn_schd.call_price is '发行人赎回价格';
comment on column ${iol_schema}.ctms_tbs_v_security_pymn_schd.put_price is '投资人回售价格';
comment on column ${iol_schema}.ctms_tbs_v_security_pymn_schd.convert_date is '转换日期';
comment on column ${iol_schema}.ctms_tbs_v_security_pymn_schd.convert_security_code is '转换债券代码';
comment on column ${iol_schema}.ctms_tbs_v_security_pymn_schd.back_announce_date is '还本公告日期';
comment on column ${iol_schema}.ctms_tbs_v_security_pymn_schd.start_dt is '开始时间';
comment on column ${iol_schema}.ctms_tbs_v_security_pymn_schd.end_dt is '结束时间';
comment on column ${iol_schema}.ctms_tbs_v_security_pymn_schd.id_mark is '增删标志';
comment on column ${iol_schema}.ctms_tbs_v_security_pymn_schd.etl_timestamp is 'ETL处理时间戳';
