/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_ap_handle_program
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_ap_handle_program
whenever sqlerror continue none;
drop table ${iol_schema}.icms_ap_handle_program purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_ap_handle_program(
    programno varchar2(64) -- 方案编号
    ,programname varchar2(1000) -- 方案名称
    ,tmsp varchar2(64) -- 
    ,inputuserid varchar2(64) -- 登记人
    ,inputorgid varchar2(64) -- 登记机构
    ,inputdate varchar2(64) -- 登记日期
    ,updateuserid varchar2(64) -- 更新人
    ,updateorgid varchar2(64) -- 更新机构
    ,updatedate varchar2(64) -- 更新日期
    ,deleteflag varchar2(12) -- 删除标志
    ,fileno varchar2(64) -- 
    ,programkind varchar2(12) -- 
    ,assetkind varchar2(12) -- 
    ,mainhandletype varchar2(12) -- 
    ,handletype varchar2(160) -- 
    ,overapproveflag varchar2(12) -- 
    ,approveno varchar2(64) -- 
    ,approveinputdate varchar2(64) -- 
    ,approveuserid varchar2(64) -- 
    ,approveorgid varchar2(64) -- 
    ,approvestatus varchar2(12) -- 审批状态
    ,handleamount number(24,6) -- 处置金额（元）
    ,paybalance number(24,6) -- 
    ,reliefbalance number(24,6) -- 
    ,reliefsum number(24,6) -- 
    ,payonbalinterest number(24,6) -- 
    ,payoutbalinterest number(24,6) -- 
    ,reliefonbalinterest number(24,6) -- 
    ,reliefoutbalinterest number(24,6) -- 
    ,prereliefbalance number(24,6) -- 
    ,preondebitinterest number(24,6) -- 
    ,preoutdebitinterest number(24,6) -- 
    ,branchbank varchar2(160) -- 分支行
    ,certtype varchar2(4) -- 
    ,certid varchar2(18) -- 借款人证件号码
    ,thridcustomer varchar2(64) -- 方案涉及第三人
    ,customername varchar2(1000) -- 方案涉及借款人
    ,customerid varchar2(100) -- 方案涉及借款人
    ,riskassetlist varchar2(2000) -- 风险资产清单
    ,approvecontent varchar2(4000) -- 
    ,remark varchar2(4000) -- 备注STRI
    ,summarize varchar2(4000) -- 方案综述
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
grant select on ${iol_schema}.icms_ap_handle_program to ${iml_schema};
grant select on ${iol_schema}.icms_ap_handle_program to ${icl_schema};
grant select on ${iol_schema}.icms_ap_handle_program to ${idl_schema};
grant select on ${iol_schema}.icms_ap_handle_program to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_ap_handle_program is '问题资产处置方案表';
comment on column ${iol_schema}.icms_ap_handle_program.programno is '方案编号';
comment on column ${iol_schema}.icms_ap_handle_program.programname is '方案名称';
comment on column ${iol_schema}.icms_ap_handle_program.tmsp is '';
comment on column ${iol_schema}.icms_ap_handle_program.inputuserid is '登记人';
comment on column ${iol_schema}.icms_ap_handle_program.inputorgid is '登记机构';
comment on column ${iol_schema}.icms_ap_handle_program.inputdate is '登记日期';
comment on column ${iol_schema}.icms_ap_handle_program.updateuserid is '更新人';
comment on column ${iol_schema}.icms_ap_handle_program.updateorgid is '更新机构';
comment on column ${iol_schema}.icms_ap_handle_program.updatedate is '更新日期';
comment on column ${iol_schema}.icms_ap_handle_program.deleteflag is '删除标志';
comment on column ${iol_schema}.icms_ap_handle_program.fileno is '';
comment on column ${iol_schema}.icms_ap_handle_program.programkind is '';
comment on column ${iol_schema}.icms_ap_handle_program.assetkind is '';
comment on column ${iol_schema}.icms_ap_handle_program.mainhandletype is '';
comment on column ${iol_schema}.icms_ap_handle_program.handletype is '';
comment on column ${iol_schema}.icms_ap_handle_program.overapproveflag is '';
comment on column ${iol_schema}.icms_ap_handle_program.approveno is '';
comment on column ${iol_schema}.icms_ap_handle_program.approveinputdate is '';
comment on column ${iol_schema}.icms_ap_handle_program.approveuserid is '';
comment on column ${iol_schema}.icms_ap_handle_program.approveorgid is '';
comment on column ${iol_schema}.icms_ap_handle_program.approvestatus is '审批状态';
comment on column ${iol_schema}.icms_ap_handle_program.handleamount is '处置金额（元）';
comment on column ${iol_schema}.icms_ap_handle_program.paybalance is '';
comment on column ${iol_schema}.icms_ap_handle_program.reliefbalance is '';
comment on column ${iol_schema}.icms_ap_handle_program.reliefsum is '';
comment on column ${iol_schema}.icms_ap_handle_program.payonbalinterest is '';
comment on column ${iol_schema}.icms_ap_handle_program.payoutbalinterest is '';
comment on column ${iol_schema}.icms_ap_handle_program.reliefonbalinterest is '';
comment on column ${iol_schema}.icms_ap_handle_program.reliefoutbalinterest is '';
comment on column ${iol_schema}.icms_ap_handle_program.prereliefbalance is '';
comment on column ${iol_schema}.icms_ap_handle_program.preondebitinterest is '';
comment on column ${iol_schema}.icms_ap_handle_program.preoutdebitinterest is '';
comment on column ${iol_schema}.icms_ap_handle_program.branchbank is '分支行';
comment on column ${iol_schema}.icms_ap_handle_program.certtype is '';
comment on column ${iol_schema}.icms_ap_handle_program.certid is '借款人证件号码';
comment on column ${iol_schema}.icms_ap_handle_program.thridcustomer is '方案涉及第三人';
comment on column ${iol_schema}.icms_ap_handle_program.customername is '方案涉及借款人';
comment on column ${iol_schema}.icms_ap_handle_program.customerid is '方案涉及借款人';
comment on column ${iol_schema}.icms_ap_handle_program.riskassetlist is '风险资产清单';
comment on column ${iol_schema}.icms_ap_handle_program.approvecontent is '';
comment on column ${iol_schema}.icms_ap_handle_program.remark is '备注STRI';
comment on column ${iol_schema}.icms_ap_handle_program.summarize is '方案综述';
comment on column ${iol_schema}.icms_ap_handle_program.migtflag is '';
comment on column ${iol_schema}.icms_ap_handle_program.start_dt is '开始时间';
comment on column ${iol_schema}.icms_ap_handle_program.end_dt is '结束时间';
comment on column ${iol_schema}.icms_ap_handle_program.id_mark is '增删标志';
comment on column ${iol_schema}.icms_ap_handle_program.etl_timestamp is 'ETL处理时间戳';
