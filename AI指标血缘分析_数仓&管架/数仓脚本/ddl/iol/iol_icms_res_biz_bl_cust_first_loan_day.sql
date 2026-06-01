/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_res_biz_bl_cust_first_loan_day
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_res_biz_bl_cust_first_loan_day
whenever sqlerror continue none;
drop table ${iol_schema}.icms_res_biz_bl_cust_first_loan_day purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_res_biz_bl_cust_first_loan_day(
    logicalcardno varchar2(19) -- 逻辑卡号
    ,custid number(20,0) -- 客户号
    ,refnbr varchar2(23) -- 首贷交易参考号
    ,bankgroupid varchar2(5) -- 参贷方案
    ,obbankproportion number -- 合作行出资比例
    ,loaninitprin number -- 放款本金
    ,obloaninitprin number -- 合作行份额放款本金
    ,firstactivatedate date -- 首贷时间
    ,reserve1 varchar2(400) -- 备份字段
    ,reserve2 varchar2(400) -- 备份字段
    ,reserve3 varchar2(400) -- 备份字段
    ,reserve4 varchar2(400) -- 备份字段
    ,reserve5 varchar2(400) -- 备份字段
    ,reserve6 varchar2(400) -- 备份字段
    ,reserve7 varchar2(400) -- 备份字段
    ,reserve8 varchar2(400) -- 备份字段
    ,reserve9 varchar2(400) -- 备份字段
    ,reserve10 varchar2(400) -- 备份字段
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
grant select on ${iol_schema}.icms_res_biz_bl_cust_first_loan_day to ${iml_schema};
grant select on ${iol_schema}.icms_res_biz_bl_cust_first_loan_day to ${icl_schema};
grant select on ${iol_schema}.icms_res_biz_bl_cust_first_loan_day to ${idl_schema};
grant select on ${iol_schema}.icms_res_biz_bl_cust_first_loan_day to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_res_biz_bl_cust_first_loan_day is '首贷客户信息表';
comment on column ${iol_schema}.icms_res_biz_bl_cust_first_loan_day.logicalcardno is '逻辑卡号';
comment on column ${iol_schema}.icms_res_biz_bl_cust_first_loan_day.custid is '客户号';
comment on column ${iol_schema}.icms_res_biz_bl_cust_first_loan_day.refnbr is '首贷交易参考号';
comment on column ${iol_schema}.icms_res_biz_bl_cust_first_loan_day.bankgroupid is '参贷方案';
comment on column ${iol_schema}.icms_res_biz_bl_cust_first_loan_day.obbankproportion is '合作行出资比例';
comment on column ${iol_schema}.icms_res_biz_bl_cust_first_loan_day.loaninitprin is '放款本金';
comment on column ${iol_schema}.icms_res_biz_bl_cust_first_loan_day.obloaninitprin is '合作行份额放款本金';
comment on column ${iol_schema}.icms_res_biz_bl_cust_first_loan_day.firstactivatedate is '首贷时间';
comment on column ${iol_schema}.icms_res_biz_bl_cust_first_loan_day.reserve1 is '备份字段';
comment on column ${iol_schema}.icms_res_biz_bl_cust_first_loan_day.reserve2 is '备份字段';
comment on column ${iol_schema}.icms_res_biz_bl_cust_first_loan_day.reserve3 is '备份字段';
comment on column ${iol_schema}.icms_res_biz_bl_cust_first_loan_day.reserve4 is '备份字段';
comment on column ${iol_schema}.icms_res_biz_bl_cust_first_loan_day.reserve5 is '备份字段';
comment on column ${iol_schema}.icms_res_biz_bl_cust_first_loan_day.reserve6 is '备份字段';
comment on column ${iol_schema}.icms_res_biz_bl_cust_first_loan_day.reserve7 is '备份字段';
comment on column ${iol_schema}.icms_res_biz_bl_cust_first_loan_day.reserve8 is '备份字段';
comment on column ${iol_schema}.icms_res_biz_bl_cust_first_loan_day.reserve9 is '备份字段';
comment on column ${iol_schema}.icms_res_biz_bl_cust_first_loan_day.reserve10 is '备份字段';
comment on column ${iol_schema}.icms_res_biz_bl_cust_first_loan_day.start_dt is '开始时间';
comment on column ${iol_schema}.icms_res_biz_bl_cust_first_loan_day.end_dt is '结束时间';
comment on column ${iol_schema}.icms_res_biz_bl_cust_first_loan_day.id_mark is '增删标志';
comment on column ${iol_schema}.icms_res_biz_bl_cust_first_loan_day.etl_timestamp is 'ETL处理时间戳';
