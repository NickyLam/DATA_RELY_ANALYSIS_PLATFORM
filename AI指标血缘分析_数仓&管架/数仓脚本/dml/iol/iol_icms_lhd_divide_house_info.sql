/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_lhd_divide_house_info
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
drop table ${iol_schema}.icms_lhd_divide_house_info_ex purge;
alter table ${iol_schema}.icms_lhd_divide_house_info add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iol_schema}.icms_lhd_divide_house_info truncate partition p_${batch_date};

-- 2.3 insert data to ex table
create table ${iol_schema}.icms_lhd_divide_house_info_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_lhd_divide_house_info where 0=1;

insert /*+ append */ into ${iol_schema}.icms_lhd_divide_house_info_ex(
    serialno -- 流水号
    ,duebillno -- 信贷借据号
    ,productid -- 产品
    ,currency -- 币种
    ,contractno -- 合同号
    ,putoutorgid -- 贷款网点
    ,ysxflag -- 预收息标识
    ,status -- 贷款状态
    ,startdate -- 起息日
    ,jxflag -- 计息标识
    ,customerid -- 客户号
    ,customername -- 客户名称
    ,classifyresult -- 五级分类
    ,putoutdate -- 贷款发放日期
    ,actualputoutsum -- 实际发放金额
    ,businesssum -- 贷款金额
    ,maturitydate -- 贷款到期日期
    ,normalrate -- 正常利率
    ,overduerate -- 逾期利率
    ,compoundrate -- 复利利率
    ,contractsum -- 合同金额
    ,isgtgsh -- 是否个体工商户
    ,enterprisesize -- 企业规模
    ,baserate -- 基准利率
    ,industrytype -- 国民经济部门类型
    ,yearbasedays -- 年基准天数
    ,customertype -- 客户类型
    ,accountstatus -- 核算状态
    ,prioverdays -- 本金逾期天数
    ,intoverdays -- 利息逾期天数
    ,czflag -- 冲正标识
    ,czdate -- 冲正日期
    ,settledate -- 结清日期
    ,termtimes -- 当前期次
    ,unmatpriamt -- 未到期本金
    ,overpriamt -- 逾期本金
    ,interest -- 利息
    ,definterest -- 罚息
    ,overint -- 逾期利息
    ,compint -- 复利
    ,overdefint -- 逾期罚息
    ,defintcomp -- 罚息的复利
    ,overcomp -- 逾期复利
    ,frontcollintamt -- 前收息金额
    ,settlechangeint -- 已结转利息
    ,settlechangedef -- 已结转罚息
    ,settlechangecomp -- 已结转复息
    ,merchantname -- 商户名称
    ,busilicenname -- 营业执照名称
    ,migttype -- 交易标志
    ,inputuserid -- 登记人
    ,inputorgid -- 登记机构
    ,inputdate -- 登记日期
    ,updateuserid -- 更新人
    ,updateorgid -- 更新机构
    ,updatedate -- 更新日期
    ,nextdate -- 下一结息日
    ,hxduebillno -- 核心借据号
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    serialno -- 流水号
    ,duebillno -- 信贷借据号
    ,productid -- 产品
    ,currency -- 币种
    ,contractno -- 合同号
    ,putoutorgid -- 贷款网点
    ,ysxflag -- 预收息标识
    ,status -- 贷款状态
    ,startdate -- 起息日
    ,jxflag -- 计息标识
    ,customerid -- 客户号
    ,customername -- 客户名称
    ,classifyresult -- 五级分类
    ,putoutdate -- 贷款发放日期
    ,actualputoutsum -- 实际发放金额
    ,businesssum -- 贷款金额
    ,maturitydate -- 贷款到期日期
    ,normalrate -- 正常利率
    ,overduerate -- 逾期利率
    ,compoundrate -- 复利利率
    ,contractsum -- 合同金额
    ,isgtgsh -- 是否个体工商户
    ,enterprisesize -- 企业规模
    ,baserate -- 基准利率
    ,industrytype -- 国民经济部门类型
    ,yearbasedays -- 年基准天数
    ,customertype -- 客户类型
    ,accountstatus -- 核算状态
    ,prioverdays -- 本金逾期天数
    ,intoverdays -- 利息逾期天数
    ,czflag -- 冲正标识
    ,czdate -- 冲正日期
    ,settledate -- 结清日期
    ,termtimes -- 当前期次
    ,unmatpriamt -- 未到期本金
    ,overpriamt -- 逾期本金
    ,interest -- 利息
    ,definterest -- 罚息
    ,overint -- 逾期利息
    ,compint -- 复利
    ,overdefint -- 逾期罚息
    ,defintcomp -- 罚息的复利
    ,overcomp -- 逾期复利
    ,frontcollintamt -- 前收息金额
    ,settlechangeint -- 已结转利息
    ,settlechangedef -- 已结转罚息
    ,settlechangecomp -- 已结转复息
    ,merchantname -- 商户名称
    ,busilicenname -- 营业执照名称
    ,migttype -- 交易标志
    ,inputuserid -- 登记人
    ,inputorgid -- 登记机构
    ,inputdate -- 登记日期
    ,updateuserid -- 更新人
    ,updateorgid -- 更新机构
    ,updatedate -- 更新日期
    ,nextdate -- 下一结息日
    ,hxduebillno -- 核心借据号
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.icms_lhd_divide_house_info
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.icms_lhd_divide_house_info exchange partition p_${batch_date} with table ${iol_schema}.icms_lhd_divide_house_info_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_lhd_divide_house_info to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.icms_lhd_divide_house_info_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_lhd_divide_house_info',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);