/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_uxds_f_yshd_service_cxssxx_root_zsxx_item
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
drop table ${iol_schema}.uxds_f_yshd_service_cxssxx_root_zsxx_item_ex purge;
alter table ${iol_schema}.uxds_f_yshd_service_cxssxx_root_zsxx_item add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iol_schema}.uxds_f_yshd_service_cxssxx_root_zsxx_item truncate partition p_${batch_date};

-- 2.3 insert data to ex table
create table ${iol_schema}.uxds_f_yshd_service_cxssxx_root_zsxx_item_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.uxds_f_yshd_service_cxssxx_root_zsxx_item where 0=1;

insert /*+ append */ into ${iol_schema}.uxds_f_yshd_service_cxssxx_root_zsxx_item_ex(
    gendate -- 生成时间
    ,serialnumber -- 业务系统流水号
    ,sequenceid -- 系统流水号
    ,nssbrq -- 纳税申报日期
    ,sbsxmc_1 -- 申报属性名称
    ,zspmmc -- 征收品目名称
    ,cbsxmc -- 查补属性名称
    ,tzlxmc -- 调账类型名称
    ,yjkqx -- 原缴款期限
    ,jkqx -- 缴款期限
    ,yjse -- 已缴税额
    ,zsxmmc -- 征收项目名称
    ,zsdlfsmc -- 征收代理方式名称
    ,zszmmc -- 征收子目名称
    ,skzlmc -- 税款种类名称
    ,ynse -- 应纳税额
    ,sbfsmc -- 申报方式名称
    ,yzfsrq -- 应征发生日期
    ,zsfsmc -- 征收方式名称
    ,shxydm -- 社会信用代码
    ,kjjzrq -- 会计记账日期
    ,kssl -- 课税数量
    ,ssqq -- 所属时间起
    ,yzpzzlmc -- 应征凭证种类名称
    ,sl_1 -- 税率
    ,ssqz -- 所属时间止
    ,item -- 关联标签
    ,czlxmc -- 操作类型名称
    ,jmse -- 减免税额
    ,ybtse -- 应补
    ,jsyj -- 计税依据
    ,sksxmc -- 税款属性名称
    ,yzgsrq -- 应征归属日期
    ,yzclrq -- 应征处理日期
    ,yjskztmc -- 税款状态名称
    ,skcllxmc -- 税款处理类型名称
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    gendate -- 生成时间
    ,serialnumber -- 业务系统流水号
    ,sequenceid -- 系统流水号
    ,nssbrq -- 纳税申报日期
    ,sbsxmc_1 -- 申报属性名称
    ,zspmmc -- 征收品目名称
    ,cbsxmc -- 查补属性名称
    ,tzlxmc -- 调账类型名称
    ,yjkqx -- 原缴款期限
    ,jkqx -- 缴款期限
    ,yjse -- 已缴税额
    ,zsxmmc -- 征收项目名称
    ,zsdlfsmc -- 征收代理方式名称
    ,zszmmc -- 征收子目名称
    ,skzlmc -- 税款种类名称
    ,ynse -- 应纳税额
    ,sbfsmc -- 申报方式名称
    ,yzfsrq -- 应征发生日期
    ,zsfsmc -- 征收方式名称
    ,shxydm -- 社会信用代码
    ,kjjzrq -- 会计记账日期
    ,kssl -- 课税数量
    ,ssqq -- 所属时间起
    ,yzpzzlmc -- 应征凭证种类名称
    ,sl_1 -- 税率
    ,ssqz -- 所属时间止
    ,item -- 关联标签
    ,czlxmc -- 操作类型名称
    ,jmse -- 减免税额
    ,ybtse -- 应补
    ,jsyj -- 计税依据
    ,sksxmc -- 税款属性名称
    ,yzgsrq -- 应征归属日期
    ,yzclrq -- 应征处理日期
    ,yjskztmc -- 税款状态名称
    ,skcllxmc -- 税款处理类型名称
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.uxds_f_yshd_service_cxssxx_root_zsxx_item
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.uxds_f_yshd_service_cxssxx_root_zsxx_item exchange partition p_${batch_date} with table ${iol_schema}.uxds_f_yshd_service_cxssxx_root_zsxx_item_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.uxds_f_yshd_service_cxssxx_root_zsxx_item to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.uxds_f_yshd_service_cxssxx_root_zsxx_item_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'uxds_f_yshd_service_cxssxx_root_zsxx_item',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);