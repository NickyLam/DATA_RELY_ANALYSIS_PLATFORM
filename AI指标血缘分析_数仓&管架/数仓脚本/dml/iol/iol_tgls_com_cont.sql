/*
Purpose:    偏源模型层-全量流水脚本，清空目标表，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_tgls_com_cont
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
drop table ${iol_schema}.tgls_com_cont_ex purge;
alter table ${iol_schema}.tgls_com_cont add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table
whenever sqlerror exit sql.sqlcode;
truncate table ${iol_schema}.tgls_com_cont;

-- 2.3 insert data to ex table
create table ${iol_schema}.tgls_com_cont_ex nologging
compress
as
select * from ${iol_schema}.tgls_com_cont where 0=1;

insert /*+ append */ into ${iol_schema}.tgls_com_cont_ex(
    contid -- 合同编号
    ,occubr -- 发生机构编号
    ,signbr -- 签约机构编号
    ,othena -- 对方名称
    ,contst -- 合同类型（01-权利，许可证照，02-营业账簿-其他账簿，03-财产保险合同，04-借款合同，05-技术合同，06-财产租赁合同，07-加工承揽合同，08-仓储保管合同，09-产权转移书据）
    ,contti -- 合同标题
    ,conttx -- 合同内容
    ,begndt -- 合同生效日
    ,endddt -- 合同到期日
    ,freest -- 免税标识：0，不免税1，免税
    ,paidst -- 是否已计提：0，未计提1，已计提
    ,conamt -- 合同金额
    ,sourst -- 合同信息来源：0，手工系统录入1，系统导入
    ,smrytx -- 备注
    ,signdt -- 合同签约日期
    ,crcycd -- 币种代码
    ,creadt -- 合同录入vat系统时间
    ,stacid -- 帐套id
    ,taxdate -- 计提日期
    ,vatxrt -- 计提税率/单价
    ,taxbam -- 计提税额
    ,claimid -- 报销单号
    ,acctbr -- 账务机构编号
    ,paydt -- 付款日期
    ,attra2 -- 企业规模
    ,attra7 -- 国民经济部门类型
    ,systid -- 系统标识
    ,conmac -- 金额/数量
    ,wtrelo -- 是否循环贷(y/n/h),与智能报销系统无关h表示不涉及
    ,salprd -- 可售产品
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    contid -- 合同编号
    ,occubr -- 发生机构编号
    ,signbr -- 签约机构编号
    ,othena -- 对方名称
    ,contst -- 合同类型（01-权利，许可证照，02-营业账簿-其他账簿，03-财产保险合同，04-借款合同，05-技术合同，06-财产租赁合同，07-加工承揽合同，08-仓储保管合同，09-产权转移书据）
    ,contti -- 合同标题
    ,conttx -- 合同内容
    ,begndt -- 合同生效日
    ,endddt -- 合同到期日
    ,freest -- 免税标识：0，不免税1，免税
    ,paidst -- 是否已计提：0，未计提1，已计提
    ,conamt -- 合同金额
    ,sourst -- 合同信息来源：0，手工系统录入1，系统导入
    ,smrytx -- 备注
    ,signdt -- 合同签约日期
    ,crcycd -- 币种代码
    ,creadt -- 合同录入vat系统时间
    ,stacid -- 帐套id
    ,taxdate -- 计提日期
    ,vatxrt -- 计提税率/单价
    ,taxbam -- 计提税额
    ,claimid -- 报销单号
    ,acctbr -- 账务机构编号
    ,paydt -- 付款日期
    ,attra2 -- 企业规模
    ,attra7 -- 国民经济部门类型
    ,systid -- 系统标识
    ,conmac -- 金额/数量
    ,wtrelo -- 是否循环贷(y/n/h),与智能报销系统无关h表示不涉及
    ,salprd -- 可售产品
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.tgls_com_cont
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.tgls_com_cont exchange partition p_${batch_date} with table ${iol_schema}.tgls_com_cont_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.tgls_com_cont to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.tgls_com_cont_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'tgls_com_cont',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);