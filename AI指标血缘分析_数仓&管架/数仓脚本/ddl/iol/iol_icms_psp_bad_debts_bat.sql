/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_psp_bad_debts_bat
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_psp_bad_debts_bat
whenever sqlerror continue none;
drop table ${iol_schema}.icms_psp_bad_debts_bat purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_psp_bad_debts_bat(
    serialno varchar2(64) -- 呆账核销批次号
    ,status varchar2(10) -- 审批状态
    ,remark varchar2(2000) -- 说明信息
    ,inputuserid varchar2(40) -- 登记人
    ,migtflag varchar2(80) -- 
    ,batdate varchar2(64) -- 呆账核销批次日期
    ,businesstype varchar2(64) -- 批次类型：0：互联网自营贷款，1：微粒贷
    ,exccertcodes varchar2(4000) -- 导入数据异常记录
    ,inputdate date -- 登记日期
    ,inputorgid varchar2(64) -- 登记机构
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
grant select on ${iol_schema}.icms_psp_bad_debts_bat to ${iml_schema};
grant select on ${iol_schema}.icms_psp_bad_debts_bat to ${icl_schema};
grant select on ${iol_schema}.icms_psp_bad_debts_bat to ${idl_schema};
grant select on ${iol_schema}.icms_psp_bad_debts_bat to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_psp_bad_debts_bat is '贷后批量核销申请信息表';
comment on column ${iol_schema}.icms_psp_bad_debts_bat.serialno is '呆账核销批次号';
comment on column ${iol_schema}.icms_psp_bad_debts_bat.status is '审批状态';
comment on column ${iol_schema}.icms_psp_bad_debts_bat.remark is '说明信息';
comment on column ${iol_schema}.icms_psp_bad_debts_bat.inputuserid is '登记人';
comment on column ${iol_schema}.icms_psp_bad_debts_bat.migtflag is '';
comment on column ${iol_schema}.icms_psp_bad_debts_bat.batdate is '呆账核销批次日期';
comment on column ${iol_schema}.icms_psp_bad_debts_bat.businesstype is '批次类型：0：互联网自营贷款，1：微粒贷';
comment on column ${iol_schema}.icms_psp_bad_debts_bat.exccertcodes is '导入数据异常记录';
comment on column ${iol_schema}.icms_psp_bad_debts_bat.inputdate is '登记日期';
comment on column ${iol_schema}.icms_psp_bad_debts_bat.inputorgid is '登记机构';
comment on column ${iol_schema}.icms_psp_bad_debts_bat.start_dt is '开始时间';
comment on column ${iol_schema}.icms_psp_bad_debts_bat.end_dt is '结束时间';
comment on column ${iol_schema}.icms_psp_bad_debts_bat.id_mark is '增删标志';
comment on column ${iol_schema}.icms_psp_bad_debts_bat.etl_timestamp is 'ETL处理时间戳';
