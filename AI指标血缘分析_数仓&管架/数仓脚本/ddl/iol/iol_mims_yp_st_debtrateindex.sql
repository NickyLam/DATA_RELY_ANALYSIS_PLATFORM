/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol mims_yp_st_debtrateindex
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.mims_yp_st_debtrateindex
whenever sqlerror continue none;
drop table ${iol_schema}.mims_yp_st_debtrateindex purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mims_yp_st_debtrateindex(
    data_dt varchar2(15) -- 数据日期:格式为yyyy-mm-dd
    ,task varchar2(30) -- 任务序号
    ,custid varchar2(45) -- 客户编号
    ,sccode varchar2(48) -- 押品编号
    ,asscontno varchar2(75) -- 担保合同号
    ,ishighasscon varchar2(2) -- 是否最高额担保,1-是,0-否
    ,guartype1 varchar2(30) -- 担保一级分类
    ,guartype2 varchar2(30) -- 担保二级分类
    ,guartype3 varchar2(30) -- 担保三级分类
    ,guaramt number(20,2) -- 抵质押金额
    ,currency varchar2(5) -- 币种
    ,guarterms number(22) -- 覆盖期限(月)
    ,effectdate varchar2(15) -- 生效日,格式yyyy-mm-dd
    ,remainterms number(22) -- 剩余覆盖期限(月)
    ,regulatorytype varchar2(3) -- 监管分类:2-金融质押品,3-其他抵质押品,4-商住房地产和居住用房地产,5-应收账款
    ,qualification varchar2(3) -- 合格性:0-不合格,1-合格
    ,releaseagent varchar2(3) -- 金融质押品发行机构:01-主权（不含公共部门实体）,02-其他发行者,03-证券化风险暴露
    ,issuercountry varchar2(15) -- 金融质押品发行人注册地所在国家或地区
    ,transtype varchar2(3) -- 交易类型:1-回购类交易、2-其他资本市场交易、3-抵押贷款
    ,evalfrequency number(22) -- 再重估频率
    ,controlchange varchar2(3) -- 质押物控制力调整系数
    ,realestateregion varchar2(15) -- 房地产所在地区
    ,etl_dt date -- ETL处理日期
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 64k next 64k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.mims_yp_st_debtrateindex to ${iml_schema};
grant select on ${iol_schema}.mims_yp_st_debtrateindex to ${icl_schema};
grant select on ${iol_schema}.mims_yp_st_debtrateindex to ${idl_schema};
grant select on ${iol_schema}.mims_yp_st_debtrateindex to ${iel_schema};

-- comment
comment on table ${iol_schema}.mims_yp_st_debtrateindex is '压力测试押品信息基本表中间表';
comment on column ${iol_schema}.mims_yp_st_debtrateindex.data_dt is '数据日期:格式为yyyy-mm-dd';
comment on column ${iol_schema}.mims_yp_st_debtrateindex.task is '任务序号';
comment on column ${iol_schema}.mims_yp_st_debtrateindex.custid is '客户编号';
comment on column ${iol_schema}.mims_yp_st_debtrateindex.sccode is '押品编号';
comment on column ${iol_schema}.mims_yp_st_debtrateindex.asscontno is '担保合同号';
comment on column ${iol_schema}.mims_yp_st_debtrateindex.ishighasscon is '是否最高额担保,1-是,0-否';
comment on column ${iol_schema}.mims_yp_st_debtrateindex.guartype1 is '担保一级分类';
comment on column ${iol_schema}.mims_yp_st_debtrateindex.guartype2 is '担保二级分类';
comment on column ${iol_schema}.mims_yp_st_debtrateindex.guartype3 is '担保三级分类';
comment on column ${iol_schema}.mims_yp_st_debtrateindex.guaramt is '抵质押金额';
comment on column ${iol_schema}.mims_yp_st_debtrateindex.currency is '币种';
comment on column ${iol_schema}.mims_yp_st_debtrateindex.guarterms is '覆盖期限(月)';
comment on column ${iol_schema}.mims_yp_st_debtrateindex.effectdate is '生效日,格式yyyy-mm-dd';
comment on column ${iol_schema}.mims_yp_st_debtrateindex.remainterms is '剩余覆盖期限(月)';
comment on column ${iol_schema}.mims_yp_st_debtrateindex.regulatorytype is '监管分类:2-金融质押品,3-其他抵质押品,4-商住房地产和居住用房地产,5-应收账款';
comment on column ${iol_schema}.mims_yp_st_debtrateindex.qualification is '合格性:0-不合格,1-合格';
comment on column ${iol_schema}.mims_yp_st_debtrateindex.releaseagent is '金融质押品发行机构:01-主权（不含公共部门实体）,02-其他发行者,03-证券化风险暴露';
comment on column ${iol_schema}.mims_yp_st_debtrateindex.issuercountry is '金融质押品发行人注册地所在国家或地区';
comment on column ${iol_schema}.mims_yp_st_debtrateindex.transtype is '交易类型:1-回购类交易、2-其他资本市场交易、3-抵押贷款';
comment on column ${iol_schema}.mims_yp_st_debtrateindex.evalfrequency is '再重估频率';
comment on column ${iol_schema}.mims_yp_st_debtrateindex.controlchange is '质押物控制力调整系数';
comment on column ${iol_schema}.mims_yp_st_debtrateindex.realestateregion is '房地产所在地区';
comment on column ${iol_schema}.mims_yp_st_debtrateindex.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.mims_yp_st_debtrateindex.etl_timestamp is 'ETL处理时间戳';
