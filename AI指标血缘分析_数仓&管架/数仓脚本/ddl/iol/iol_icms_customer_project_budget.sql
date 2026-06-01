/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_customer_project_budget
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_customer_project_budget
whenever sqlerror continue none;
drop table ${iol_schema}.icms_customer_project_budget purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_customer_project_budget(
    projectno varchar2(64) -- 项目编号
    ,exestype varchar2(36) -- 费用类型
    ,inputorgid varchar2(64) -- 登记机构
    ,othercost number(24,6) -- 其他费用
    ,remark varchar2(1000) -- 备注
    ,risepreparecost number(24,6) -- 涨价预备费
    ,housetotal number(24,6) -- 住宅销售合计
    ,expectbenefit varchar2(1000) -- 预计效益情况
    ,landcost number(24,6) -- 土地费用
    ,shopsaverage number(24,6) -- 商铺销售均价
    ,shopstotal number(24,6) -- 商铺销售合计
    ,officetotal number(24,6) -- 写字间销售合计
    ,updateuserid varchar2(64) -- 更新人
    ,constructionperiodinterest number(24,6) -- 建设期利息
    ,unforeseencost number(24,6) -- 不可预见费
    ,carportaverage number(24,6) -- 车库销售均价
    ,total number(24,6) -- 合计
    ,inputuserid varchar2(64) -- 登记人
    ,updateorgid varchar2(64) -- 更新机构
    ,exesname varchar2(160) -- 费用名称
    ,exescurrency varchar2(3) -- 费用币种
    ,workingcapital number(24,6) -- 流动资金
    ,totalcost number(24,6) -- 总计
    ,investpayback number(22) -- 投资回收期
    ,loanpayback number(22) -- 贷款回收期
    ,corporgid varchar2(64) -- 法人机构编号
    ,subsidiarydevelopcost number(24,6) -- 附属工程开发费
    ,taxation number(24,6) -- 税费
    ,earlyprojectcost number(24,6) -- 前期工程费
    ,inputdate date -- 登记日期
    ,equipmentcost number(24,6) -- 设备费用
    ,carporttotal number(24,6) -- 车库销售合计
    ,landtotal number(24,6) -- 土地销售收入合计
    ,updatedate date -- 更新日期
    ,migtflag varchar2(80) -- 
    ,civilengineeringdevelopcost number(24,6) -- 土建工程开发费
    ,installdevelopcost number(24,6) -- 建筑安装工程开发费
    ,managecost number(24,6) -- 管理费用
    ,landaverage number(24,6) -- 土地销售均价
    ,sellingcost number(24,6) -- 销售费用
    ,officeaverage number(24,6) -- 写字间销售均价
    ,projectcost number(24,6) -- 工程费用
    ,financecost number(24,6) -- 财务费用
    ,houseaverage number(24,6) -- 住宅销售均价
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
grant select on ${iol_schema}.icms_customer_project_budget to ${iml_schema};
grant select on ${iol_schema}.icms_customer_project_budget to ${icl_schema};
grant select on ${iol_schema}.icms_customer_project_budget to ${idl_schema};
grant select on ${iol_schema}.icms_customer_project_budget to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_customer_project_budget is '项目投资概算项目投资概算';
comment on column ${iol_schema}.icms_customer_project_budget.projectno is '项目编号';
comment on column ${iol_schema}.icms_customer_project_budget.exestype is '费用类型';
comment on column ${iol_schema}.icms_customer_project_budget.inputorgid is '登记机构';
comment on column ${iol_schema}.icms_customer_project_budget.othercost is '其他费用';
comment on column ${iol_schema}.icms_customer_project_budget.remark is '备注';
comment on column ${iol_schema}.icms_customer_project_budget.risepreparecost is '涨价预备费';
comment on column ${iol_schema}.icms_customer_project_budget.housetotal is '住宅销售合计';
comment on column ${iol_schema}.icms_customer_project_budget.expectbenefit is '预计效益情况';
comment on column ${iol_schema}.icms_customer_project_budget.landcost is '土地费用';
comment on column ${iol_schema}.icms_customer_project_budget.shopsaverage is '商铺销售均价';
comment on column ${iol_schema}.icms_customer_project_budget.shopstotal is '商铺销售合计';
comment on column ${iol_schema}.icms_customer_project_budget.officetotal is '写字间销售合计';
comment on column ${iol_schema}.icms_customer_project_budget.updateuserid is '更新人';
comment on column ${iol_schema}.icms_customer_project_budget.constructionperiodinterest is '建设期利息';
comment on column ${iol_schema}.icms_customer_project_budget.unforeseencost is '不可预见费';
comment on column ${iol_schema}.icms_customer_project_budget.carportaverage is '车库销售均价';
comment on column ${iol_schema}.icms_customer_project_budget.total is '合计';
comment on column ${iol_schema}.icms_customer_project_budget.inputuserid is '登记人';
comment on column ${iol_schema}.icms_customer_project_budget.updateorgid is '更新机构';
comment on column ${iol_schema}.icms_customer_project_budget.exesname is '费用名称';
comment on column ${iol_schema}.icms_customer_project_budget.exescurrency is '费用币种';
comment on column ${iol_schema}.icms_customer_project_budget.workingcapital is '流动资金';
comment on column ${iol_schema}.icms_customer_project_budget.totalcost is '总计';
comment on column ${iol_schema}.icms_customer_project_budget.investpayback is '投资回收期';
comment on column ${iol_schema}.icms_customer_project_budget.loanpayback is '贷款回收期';
comment on column ${iol_schema}.icms_customer_project_budget.corporgid is '法人机构编号';
comment on column ${iol_schema}.icms_customer_project_budget.subsidiarydevelopcost is '附属工程开发费';
comment on column ${iol_schema}.icms_customer_project_budget.taxation is '税费';
comment on column ${iol_schema}.icms_customer_project_budget.earlyprojectcost is '前期工程费';
comment on column ${iol_schema}.icms_customer_project_budget.inputdate is '登记日期';
comment on column ${iol_schema}.icms_customer_project_budget.equipmentcost is '设备费用';
comment on column ${iol_schema}.icms_customer_project_budget.carporttotal is '车库销售合计';
comment on column ${iol_schema}.icms_customer_project_budget.landtotal is '土地销售收入合计';
comment on column ${iol_schema}.icms_customer_project_budget.updatedate is '更新日期';
comment on column ${iol_schema}.icms_customer_project_budget.migtflag is '';
comment on column ${iol_schema}.icms_customer_project_budget.civilengineeringdevelopcost is '土建工程开发费';
comment on column ${iol_schema}.icms_customer_project_budget.installdevelopcost is '建筑安装工程开发费';
comment on column ${iol_schema}.icms_customer_project_budget.managecost is '管理费用';
comment on column ${iol_schema}.icms_customer_project_budget.landaverage is '土地销售均价';
comment on column ${iol_schema}.icms_customer_project_budget.sellingcost is '销售费用';
comment on column ${iol_schema}.icms_customer_project_budget.officeaverage is '写字间销售均价';
comment on column ${iol_schema}.icms_customer_project_budget.projectcost is '工程费用';
comment on column ${iol_schema}.icms_customer_project_budget.financecost is '财务费用';
comment on column ${iol_schema}.icms_customer_project_budget.houseaverage is '住宅销售均价';
comment on column ${iol_schema}.icms_customer_project_budget.start_dt is '开始时间';
comment on column ${iol_schema}.icms_customer_project_budget.end_dt is '结束时间';
comment on column ${iol_schema}.icms_customer_project_budget.id_mark is '增删标志';
comment on column ${iol_schema}.icms_customer_project_budget.etl_timestamp is 'ETL处理时间戳';
