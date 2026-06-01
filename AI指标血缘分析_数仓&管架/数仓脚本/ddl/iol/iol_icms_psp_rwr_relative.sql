/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_psp_rwr_relative
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_psp_rwr_relative
whenever sqlerror continue none;
drop table ${iol_schema}.icms_psp_rwr_relative purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_psp_rwr_relative(
    warningruleno varchar2(64) -- 预警规则编号
    ,warningsignalno varchar2(64) -- 预警信号编号
    ,inputuserid varchar2(64) -- 登记人
    ,inputorgid varchar2(64) -- 登记机构
    ,inputdate date -- 登记日期
    ,updatedate date -- 更新日期
    ,updateorgid varchar2(64) -- 更新机构
    ,updateuserid varchar2(64) -- 更新人
    ,warningcode varchar2(64) -- 预警规则代码
    ,warningsign varchar2(100) -- 预警信号规则名称
    ,warningrule varchar2(800) -- 预警规则（内容）
    ,signlevel varchar2(2) -- 预警信号级别
    ,migtflag varchar2(80) -- 迁移标识
    ,duebillserialno varchar2(64) -- 借据编号
    ,kgsurl varchar2(400) -- 知识图谱链接
    ,tokenid varchar2(64) -- 进件tokenId
    ,finaldecisionname varchar2(32) -- 最终决策结果名称
    ,rulesets varchar2(255) -- 规则集详情
    ,rulesetscode varchar2(255) -- 规则集编码
    ,phonereason varchar2(4000) -- 手机号码入库原因
    ,creatreason varchar2(4000) -- 证件号码入库原因
    ,companyreason varchar2(4000) -- 企业名称入库原因
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
grant select on ${iol_schema}.icms_psp_rwr_relative to ${iml_schema};
grant select on ${iol_schema}.icms_psp_rwr_relative to ${icl_schema};
grant select on ${iol_schema}.icms_psp_rwr_relative to ${idl_schema};
grant select on ${iol_schema}.icms_psp_rwr_relative to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_psp_rwr_relative is '风险预警信号规则配置关联表';
comment on column ${iol_schema}.icms_psp_rwr_relative.warningruleno is '预警规则编号';
comment on column ${iol_schema}.icms_psp_rwr_relative.warningsignalno is '预警信号编号';
comment on column ${iol_schema}.icms_psp_rwr_relative.inputuserid is '登记人';
comment on column ${iol_schema}.icms_psp_rwr_relative.inputorgid is '登记机构';
comment on column ${iol_schema}.icms_psp_rwr_relative.inputdate is '登记日期';
comment on column ${iol_schema}.icms_psp_rwr_relative.updatedate is '更新日期';
comment on column ${iol_schema}.icms_psp_rwr_relative.updateorgid is '更新机构';
comment on column ${iol_schema}.icms_psp_rwr_relative.updateuserid is '更新人';
comment on column ${iol_schema}.icms_psp_rwr_relative.warningcode is '预警规则代码';
comment on column ${iol_schema}.icms_psp_rwr_relative.warningsign is '预警信号规则名称';
comment on column ${iol_schema}.icms_psp_rwr_relative.warningrule is '预警规则（内容）';
comment on column ${iol_schema}.icms_psp_rwr_relative.signlevel is '预警信号级别';
comment on column ${iol_schema}.icms_psp_rwr_relative.migtflag is '迁移标识';
comment on column ${iol_schema}.icms_psp_rwr_relative.duebillserialno is '借据编号';
comment on column ${iol_schema}.icms_psp_rwr_relative.kgsurl is '知识图谱链接';
comment on column ${iol_schema}.icms_psp_rwr_relative.tokenid is '进件tokenId';
comment on column ${iol_schema}.icms_psp_rwr_relative.finaldecisionname is '最终决策结果名称';
comment on column ${iol_schema}.icms_psp_rwr_relative.rulesets is '规则集详情';
comment on column ${iol_schema}.icms_psp_rwr_relative.rulesetscode is '规则集编码';
comment on column ${iol_schema}.icms_psp_rwr_relative.phonereason is '手机号码入库原因';
comment on column ${iol_schema}.icms_psp_rwr_relative.creatreason is '证件号码入库原因';
comment on column ${iol_schema}.icms_psp_rwr_relative.companyreason is '企业名称入库原因';
comment on column ${iol_schema}.icms_psp_rwr_relative.start_dt is '开始时间';
comment on column ${iol_schema}.icms_psp_rwr_relative.end_dt is '结束时间';
comment on column ${iol_schema}.icms_psp_rwr_relative.id_mark is '增删标志';
comment on column ${iol_schema}.icms_psp_rwr_relative.etl_timestamp is 'ETL处理时间戳';
