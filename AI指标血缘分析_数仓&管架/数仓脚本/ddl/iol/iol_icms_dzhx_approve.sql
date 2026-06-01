/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_dzhx_approve
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_dzhx_approve
whenever sqlerror continue none;
drop table ${iol_schema}.icms_dzhx_approve purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_dzhx_approve(
    customerid varchar2(32) -- 客户编号
    ,customername varchar2(200) -- 客户名称
    ,attribute2 varchar2(32) -- 内部户
    ,remark1 varchar2(3000) -- 对借款人（或股权）追偿情况及结果
    ,mainrepresent varchar2(100) -- 借款人法定代表人
    ,violateserialno varchar2(60) -- 借款人被判触犯刑律文号
    ,otherserialno varchar2(60) -- 其他部门证明文号
    ,attribute1 number(24,6) -- 诉讼费（汇总）
    ,inputorgid varchar2(12) -- 登记机构
    ,hxoutinterest number(24,6) -- 核销表外利息
    ,cancellicensedate varchar2(32) -- 工商部门注销（或吊销）借款人营业执照时间
    ,updateuserid varchar2(8) -- 更新人
    ,remark2 varchar2(2000) -- 对保证人、抵押/质押物追偿情况及结果
    ,inputdate date -- 登记时间
    ,certtype varchar2(5) -- 证件类型
    ,hxmoney number(24,6) -- 核销本金（汇总）
    ,remark3 varchar2(2000) -- 责任人认定及责任人处理结果
    ,ifsearch varchar2(2) -- 是否保留对债务人的追索权
    ,imputorgid varchar2(2) -- 登记机构
    ,migtflag varchar2(80) -- 
    ,certid varchar2(60) -- 证件号码
    ,entproperty varchar2(32) -- 企业性质
    ,courtdecisiondate date -- 法院最终裁定时间
    ,inputuserid varchar2(8) -- 登记人
    ,courtdecisionserialno varchar2(90) -- 法院最终裁定文号
    ,hxininterest number(24,6) -- 核销表内利息
    ,updatedate date -- 更新时间
    ,otherdate date -- 其他部门证明时间
    ,approvehxdate date -- 审批核销时间
    ,approvehxsum number(24,6) -- 核销金额（审批通过）
    ,remark varchar2(3000) -- 呆账形成原因
    ,industry varchar2(32) -- 所属行业
    ,violatedate date -- 借款人被判触犯刑律时间
    ,hxtype varchar2(32) -- 核销类型
    ,updateorgid varchar2(12) -- 更新机构
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
grant select on ${iol_schema}.icms_dzhx_approve to ${iml_schema};
grant select on ${iol_schema}.icms_dzhx_approve to ${icl_schema};
grant select on ${iol_schema}.icms_dzhx_approve to ${idl_schema};
grant select on ${iol_schema}.icms_dzhx_approve to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_dzhx_approve is '呆账核销审批记录';
comment on column ${iol_schema}.icms_dzhx_approve.customerid is '客户编号';
comment on column ${iol_schema}.icms_dzhx_approve.customername is '客户名称';
comment on column ${iol_schema}.icms_dzhx_approve.attribute2 is '内部户';
comment on column ${iol_schema}.icms_dzhx_approve.remark1 is '对借款人（或股权）追偿情况及结果';
comment on column ${iol_schema}.icms_dzhx_approve.mainrepresent is '借款人法定代表人';
comment on column ${iol_schema}.icms_dzhx_approve.violateserialno is '借款人被判触犯刑律文号';
comment on column ${iol_schema}.icms_dzhx_approve.otherserialno is '其他部门证明文号';
comment on column ${iol_schema}.icms_dzhx_approve.attribute1 is '诉讼费（汇总）';
comment on column ${iol_schema}.icms_dzhx_approve.inputorgid is '登记机构';
comment on column ${iol_schema}.icms_dzhx_approve.hxoutinterest is '核销表外利息';
comment on column ${iol_schema}.icms_dzhx_approve.cancellicensedate is '工商部门注销（或吊销）借款人营业执照时间';
comment on column ${iol_schema}.icms_dzhx_approve.updateuserid is '更新人';
comment on column ${iol_schema}.icms_dzhx_approve.remark2 is '对保证人、抵押/质押物追偿情况及结果';
comment on column ${iol_schema}.icms_dzhx_approve.inputdate is '登记时间';
comment on column ${iol_schema}.icms_dzhx_approve.certtype is '证件类型';
comment on column ${iol_schema}.icms_dzhx_approve.hxmoney is '核销本金（汇总）';
comment on column ${iol_schema}.icms_dzhx_approve.remark3 is '责任人认定及责任人处理结果';
comment on column ${iol_schema}.icms_dzhx_approve.ifsearch is '是否保留对债务人的追索权';
comment on column ${iol_schema}.icms_dzhx_approve.imputorgid is '登记机构';
comment on column ${iol_schema}.icms_dzhx_approve.migtflag is '';
comment on column ${iol_schema}.icms_dzhx_approve.certid is '证件号码';
comment on column ${iol_schema}.icms_dzhx_approve.entproperty is '企业性质';
comment on column ${iol_schema}.icms_dzhx_approve.courtdecisiondate is '法院最终裁定时间';
comment on column ${iol_schema}.icms_dzhx_approve.inputuserid is '登记人';
comment on column ${iol_schema}.icms_dzhx_approve.courtdecisionserialno is '法院最终裁定文号';
comment on column ${iol_schema}.icms_dzhx_approve.hxininterest is '核销表内利息';
comment on column ${iol_schema}.icms_dzhx_approve.updatedate is '更新时间';
comment on column ${iol_schema}.icms_dzhx_approve.otherdate is '其他部门证明时间';
comment on column ${iol_schema}.icms_dzhx_approve.approvehxdate is '审批核销时间';
comment on column ${iol_schema}.icms_dzhx_approve.approvehxsum is '核销金额（审批通过）';
comment on column ${iol_schema}.icms_dzhx_approve.remark is '呆账形成原因';
comment on column ${iol_schema}.icms_dzhx_approve.industry is '所属行业';
comment on column ${iol_schema}.icms_dzhx_approve.violatedate is '借款人被判触犯刑律时间';
comment on column ${iol_schema}.icms_dzhx_approve.hxtype is '核销类型';
comment on column ${iol_schema}.icms_dzhx_approve.updateorgid is '更新机构';
comment on column ${iol_schema}.icms_dzhx_approve.start_dt is '开始时间';
comment on column ${iol_schema}.icms_dzhx_approve.end_dt is '结束时间';
comment on column ${iol_schema}.icms_dzhx_approve.id_mark is '增删标志';
comment on column ${iol_schema}.icms_dzhx_approve.etl_timestamp is 'ETL处理时间戳';
