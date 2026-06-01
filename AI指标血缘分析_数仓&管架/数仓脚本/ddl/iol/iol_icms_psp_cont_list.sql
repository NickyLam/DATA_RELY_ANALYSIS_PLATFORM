/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_psp_cont_list
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_psp_cont_list
whenever sqlerror continue none;
drop table ${iol_schema}.icms_psp_cont_list purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_psp_cont_list(
    serialno varchar2(32) -- 主键
    ,prdpk varchar2(32) -- 产品主键
    ,mainbrid varchar2(20) -- 所属分行
    ,assuremeansmain varchar2(2) -- 担保方式
    ,prdname varchar2(60) -- 产品名称
    ,contamt number(16,2) -- 合同额度金额
    ,availriskamt number(16,2) -- 敞口余额
    ,biztypesub varchar2(8) -- 产品类别
    ,availamt number(16,2) -- 使用余额
    ,contno varchar2(30) -- 合同编号
    ,loanenddate varchar2(20) -- 额度到期日
    ,biztype varchar2(20) -- 贷款品种
    ,contriskamt number(16,2) -- 合同敞口金额
    ,type varchar2(1) -- 我行授信情况区别:1、借款人2、保证人
    ,cusid varchar2(30) -- 客户号
    ,serno varchar2(32) -- 任务编号
    ,currencytype varchar2(3) -- 币种
    ,cusname varchar2(200) -- 客户名称
    ,migtflag varchar2(80) -- 
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
grant select on ${iol_schema}.icms_psp_cont_list to ${iml_schema};
grant select on ${iol_schema}.icms_psp_cont_list to ${icl_schema};
grant select on ${iol_schema}.icms_psp_cont_list to ${idl_schema};
grant select on ${iol_schema}.icms_psp_cont_list to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_psp_cont_list is '借款人在我行授信信息（单位：元）';
comment on column ${iol_schema}.icms_psp_cont_list.serialno is '主键';
comment on column ${iol_schema}.icms_psp_cont_list.prdpk is '产品主键';
comment on column ${iol_schema}.icms_psp_cont_list.mainbrid is '所属分行';
comment on column ${iol_schema}.icms_psp_cont_list.assuremeansmain is '担保方式';
comment on column ${iol_schema}.icms_psp_cont_list.prdname is '产品名称';
comment on column ${iol_schema}.icms_psp_cont_list.contamt is '合同额度金额';
comment on column ${iol_schema}.icms_psp_cont_list.availriskamt is '敞口余额';
comment on column ${iol_schema}.icms_psp_cont_list.biztypesub is '产品类别';
comment on column ${iol_schema}.icms_psp_cont_list.availamt is '使用余额';
comment on column ${iol_schema}.icms_psp_cont_list.contno is '合同编号';
comment on column ${iol_schema}.icms_psp_cont_list.loanenddate is '额度到期日';
comment on column ${iol_schema}.icms_psp_cont_list.biztype is '贷款品种';
comment on column ${iol_schema}.icms_psp_cont_list.contriskamt is '合同敞口金额';
comment on column ${iol_schema}.icms_psp_cont_list.type is '我行授信情况区别:1、借款人2、保证人';
comment on column ${iol_schema}.icms_psp_cont_list.cusid is '客户号';
comment on column ${iol_schema}.icms_psp_cont_list.serno is '任务编号';
comment on column ${iol_schema}.icms_psp_cont_list.currencytype is '币种';
comment on column ${iol_schema}.icms_psp_cont_list.cusname is '客户名称';
comment on column ${iol_schema}.icms_psp_cont_list.migtflag is '';
comment on column ${iol_schema}.icms_psp_cont_list.start_dt is '开始时间';
comment on column ${iol_schema}.icms_psp_cont_list.end_dt is '结束时间';
comment on column ${iol_schema}.icms_psp_cont_list.id_mark is '增删标志';
comment on column ${iol_schema}.icms_psp_cont_list.etl_timestamp is 'ETL处理时间戳';
