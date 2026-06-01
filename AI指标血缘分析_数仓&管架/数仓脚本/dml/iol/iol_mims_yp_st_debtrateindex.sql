/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_mims_yp_st_debtrateindex
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建脚本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 8;
alter session force parallel dml parallel 8;
-- alter session force parallel ddl parallel 8;

-- 2.1 create table for exchage and add partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.mims_yp_st_debtrateindex_ex purge;
alter table ${iol_schema}.mims_yp_st_debtrateindex add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iol_schema}.mims_yp_st_debtrateindex truncate partition p_${batch_date};

-- 2.3 insert data to ex table
create table ${iol_schema}.mims_yp_st_debtrateindex_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.mims_yp_st_debtrateindex where 0=1;

insert /*+ append */ into ${iol_schema}.mims_yp_st_debtrateindex_ex(
    data_dt -- 数据日期:格式为YYYY-MM-DD
    ,task -- 任务序号
    ,custid -- 客户编号
    ,sccode -- 押品编号
    ,asscontno -- 担保合同号
    ,ishighasscon -- 是否最高额担保,1-是,0-否
    ,guartype1 -- 担保一级分类
    ,guartype2 -- 担保二级分类
    ,guartype3 -- 担保三级分类
    ,guaramt -- 抵质押金额
    ,currency -- 币种
    ,guarterms -- 覆盖期限(月)
    ,effectdate -- 生效日,格式YYYY-MM-DD
    ,remainterms -- 剩余覆盖期限(月)
    ,regulatorytype -- 监管分类:2-金融质押品,3-其他抵质押品,4-商住房地产和居住用房地产,5-应收账款
    ,qualification -- 合格性:0-不合格,1-合格
    ,releaseagent -- 金融质押品发行机构:01-主权（不含公共部门实体）,02-其他发行者,03-证券化风险暴露
    ,issuercountry -- 金融质押品发行人注册地所在国家或地区
    ,transtype -- 交易类型:1-回购类交易、2-其他资本市场交易、3-抵押贷款
    ,evalfrequency -- 再重估频率
    ,controlchange -- 质押物控制力调整系数
    ,realestateregion -- 房地产所在地区
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    data_dt -- 数据日期:格式为YYYY-MM-DD
    ,task -- 任务序号
    ,custid -- 客户编号
    ,sccode -- 押品编号
    ,asscontno -- 担保合同号
    ,ishighasscon -- 是否最高额担保,1-是,0-否
    ,guartype1 -- 担保一级分类
    ,guartype2 -- 担保二级分类
    ,guartype3 -- 担保三级分类
    ,guaramt -- 抵质押金额
    ,currency -- 币种
    ,guarterms -- 覆盖期限(月)
    ,effectdate -- 生效日,格式YYYY-MM-DD
    ,remainterms -- 剩余覆盖期限(月)
    ,regulatorytype -- 监管分类:2-金融质押品,3-其他抵质押品,4-商住房地产和居住用房地产,5-应收账款
    ,qualification -- 合格性:0-不合格,1-合格
    ,releaseagent -- 金融质押品发行机构:01-主权（不含公共部门实体）,02-其他发行者,03-证券化风险暴露
    ,issuercountry -- 金融质押品发行人注册地所在国家或地区
    ,transtype -- 交易类型:1-回购类交易、2-其他资本市场交易、3-抵押贷款
    ,evalfrequency -- 再重估频率
    ,controlchange -- 质押物控制力调整系数
    ,realestateregion -- 房地产所在地区
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.mims_yp_st_debtrateindex
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.mims_yp_st_debtrateindex exchange partition p_${batch_date} with table ${iol_schema}.mims_yp_st_debtrateindex_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.mims_yp_st_debtrateindex to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.mims_yp_st_debtrateindex_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'mims_yp_st_debtrateindex',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);