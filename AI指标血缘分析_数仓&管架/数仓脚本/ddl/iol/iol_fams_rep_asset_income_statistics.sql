/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol fams_rep_asset_income_statistics
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.fams_rep_asset_income_statistics
whenever sqlerror continue none;
drop table ${iol_schema}.fams_rep_asset_income_statistics purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.fams_rep_asset_income_statistics(
    cdate varchar2(50) -- 日期
    ,assetcode varchar2(50) -- 资产编码
    ,assetname varchar2(200) -- 资产名称
    ,vdate varchar2(50) -- 资产起息日
    ,mdate varchar2(50) -- 资产到期日
    ,cmdate varchar2(50) -- 负债到期日
    ,basis_name varchar2(200) -- 计息基础
    ,issue_amt number(30,2) -- 初始发行金额
    ,position number(30,2) -- 存续金额
    ,custrate number(30,2) -- 资产收益率%
    ,ratio_rate number(30,2) -- 分行分成比例%
    ,capital_rate number(30,2) -- 资金成本
    ,debt_cost varchar2(500) -- 负债成本
    ,share_amt_pre_tax number(30,2) -- 分行分成金额
    ,share_amt number(30,2) -- 分行分成金额-税后
    ,adjust_amt_pre_tax number(30,2) -- 调整分成金额
    ,adjust_amt number(30,2) -- 调整分成金额-税后
    ,share_amount_pre_tax number(30,2) -- 分行分成合计
    ,share_amount number(30,2) -- 分行分成合计-税后
    ,org_code varchar2(32) -- 机构代码
    ,org_name varchar2(50) -- 机构名称
    ,remark varchar2(1000) -- 备注
    ,create_user varchar2(20) -- 创建人
    ,create_dept varchar2(32) -- 创建部门
    ,create_time timestamp -- 创建时间
    ,update_user varchar2(20) -- 更新人
    ,update_time timestamp -- 更新时间
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
grant select on ${iol_schema}.fams_rep_asset_income_statistics to ${iml_schema};
grant select on ${iol_schema}.fams_rep_asset_income_statistics to ${icl_schema};
grant select on ${iol_schema}.fams_rep_asset_income_statistics to ${idl_schema};
grant select on ${iol_schema}.fams_rep_asset_income_statistics to ${iel_schema};

-- comment
comment on table ${iol_schema}.fams_rep_asset_income_statistics is '报表单据-总分联动收入统计表';
comment on column ${iol_schema}.fams_rep_asset_income_statistics.cdate is '日期';
comment on column ${iol_schema}.fams_rep_asset_income_statistics.assetcode is '资产编码';
comment on column ${iol_schema}.fams_rep_asset_income_statistics.assetname is '资产名称';
comment on column ${iol_schema}.fams_rep_asset_income_statistics.vdate is '资产起息日';
comment on column ${iol_schema}.fams_rep_asset_income_statistics.mdate is '资产到期日';
comment on column ${iol_schema}.fams_rep_asset_income_statistics.cmdate is '负债到期日';
comment on column ${iol_schema}.fams_rep_asset_income_statistics.basis_name is '计息基础';
comment on column ${iol_schema}.fams_rep_asset_income_statistics.issue_amt is '初始发行金额';
comment on column ${iol_schema}.fams_rep_asset_income_statistics.position is '存续金额';
comment on column ${iol_schema}.fams_rep_asset_income_statistics.custrate is '资产收益率%';
comment on column ${iol_schema}.fams_rep_asset_income_statistics.ratio_rate is '分行分成比例%';
comment on column ${iol_schema}.fams_rep_asset_income_statistics.capital_rate is '资金成本';
comment on column ${iol_schema}.fams_rep_asset_income_statistics.debt_cost is '负债成本';
comment on column ${iol_schema}.fams_rep_asset_income_statistics.share_amt_pre_tax is '分行分成金额';
comment on column ${iol_schema}.fams_rep_asset_income_statistics.share_amt is '分行分成金额-税后';
comment on column ${iol_schema}.fams_rep_asset_income_statistics.adjust_amt_pre_tax is '调整分成金额';
comment on column ${iol_schema}.fams_rep_asset_income_statistics.adjust_amt is '调整分成金额-税后';
comment on column ${iol_schema}.fams_rep_asset_income_statistics.share_amount_pre_tax is '分行分成合计';
comment on column ${iol_schema}.fams_rep_asset_income_statistics.share_amount is '分行分成合计-税后';
comment on column ${iol_schema}.fams_rep_asset_income_statistics.org_code is '机构代码';
comment on column ${iol_schema}.fams_rep_asset_income_statistics.org_name is '机构名称';
comment on column ${iol_schema}.fams_rep_asset_income_statistics.remark is '备注';
comment on column ${iol_schema}.fams_rep_asset_income_statistics.create_user is '创建人';
comment on column ${iol_schema}.fams_rep_asset_income_statistics.create_dept is '创建部门';
comment on column ${iol_schema}.fams_rep_asset_income_statistics.create_time is '创建时间';
comment on column ${iol_schema}.fams_rep_asset_income_statistics.update_user is '更新人';
comment on column ${iol_schema}.fams_rep_asset_income_statistics.update_time is '更新时间';
comment on column ${iol_schema}.fams_rep_asset_income_statistics.start_dt is '开始时间';
comment on column ${iol_schema}.fams_rep_asset_income_statistics.end_dt is '结束时间';
comment on column ${iol_schema}.fams_rep_asset_income_statistics.id_mark is '增删标志';
comment on column ${iol_schema}.fams_rep_asset_income_statistics.etl_timestamp is 'ETL处理时间戳';
