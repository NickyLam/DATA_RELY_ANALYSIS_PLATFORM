/*
Purpose:    技术缓冲层脚本，把数据文件加载到目标表的当天分区中。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd itl_itl_edw_ncbs_tb_tailbox
CreateDate: 20180515
Logs:
    luzd 2019-05-27 新建脚本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 8;
alter session force parallel dml parallel 8;
-- alter session force parallel ddl parallel 8;


-- 2.1 drop timeout partition and add partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none;
alter table ${itl_schema}.itl_edw_ncbs_tb_tailbox drop partition p_${retain_day};
alter table ${itl_schema}.itl_edw_ncbs_tb_tailbox drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${itl_schema}.itl_edw_ncbs_tb_tailbox add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${itl_schema}.itl_edw_ncbs_tb_tailbox partition for (to_date('${batch_date}','yyyymmdd')) (
    eod_voucher_equal -- 日终凭证碰库标志
    ,branch -- 机构编号
    ,user_id -- 交易柜员编号
    ,company -- 法人
    ,tailbox_id -- 尾箱代号
    ,tailbox_property -- 尾箱属性
    ,tailbox_status -- 尾箱状态
    ,tailbox_type -- 尾箱类型
    ,create_date -- 创建日期
    ,tran_timestamp -- 交易时间戳
    ,update_date -- 更新日期
    ,assign_user_id -- 分配柜员
    ,last_user_id -- 上一柜员id
    ,sod_cash_equal -- 日始现金碰库标识
    ,sod_voucher_equal -- 日始凭证碰库标识
    ,eod_cash_equal -- 日终现金碰库标志
    ,teller_bind_type -- 柜员绑定关系
    ,voucher_equal_timestamp -- 凭证碰库时间戳
    ,cash_equal_timestamp -- 现金碰库时间戳
    ,tailbox_sub_type -- 尾箱细类
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间
)
select
    nvl(trim(eod_voucher_equal), ' ') as eod_voucher_equal -- 日终凭证碰库标志
    ,nvl(trim(branch), ' ') as branch -- 机构编号
    ,nvl(trim(user_id), ' ') as user_id -- 交易柜员编号
    ,nvl(trim(company), ' ') as company -- 法人
    ,nvl(trim(tailbox_id), ' ') as tailbox_id -- 尾箱代号
    ,nvl(trim(tailbox_property), ' ') as tailbox_property -- 尾箱属性
    ,nvl(trim(tailbox_status), ' ') as tailbox_status -- 尾箱状态
    ,nvl(trim(tailbox_type), ' ') as tailbox_type -- 尾箱类型
    ,nvl(create_date, to_date('00010101', 'yyyymmdd')) as create_date -- 创建日期
    ,nvl(trim(tran_timestamp), ' ') as tran_timestamp -- 交易时间戳
    ,nvl(update_date, to_date('00010101', 'yyyymmdd')) as update_date -- 更新日期
    ,nvl(trim(assign_user_id), ' ') as assign_user_id -- 分配柜员
    ,nvl(trim(last_user_id), ' ') as last_user_id -- 上一柜员id
    ,nvl(trim(sod_cash_equal), ' ') as sod_cash_equal -- 日始现金碰库标识
    ,nvl(trim(sod_voucher_equal), ' ') as sod_voucher_equal -- 日始凭证碰库标识
    ,nvl(trim(eod_cash_equal), ' ') as eod_cash_equal -- 日终现金碰库标志
    ,nvl(trim(teller_bind_type), ' ') as teller_bind_type -- 柜员绑定关系
    ,nvl(trim(voucher_equal_timestamp), ' ') as voucher_equal_timestamp -- 凭证碰库时间戳
    ,nvl(trim(cash_equal_timestamp), ' ') as cash_equal_timestamp -- 现金碰库时间戳
    ,nvl(trim(tailbox_sub_type), ' ') as tailbox_sub_type -- 尾箱细类
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${msl_schema}.msl_edw_ncbs_tb_tailbox
 where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')
 ;
commit;

-- 3 table grant
whenever sqlerror exit sql.sqlcode;
grant select on ${itl_schema}.itl_edw_ncbs_tb_tailbox to ${iol_schema};

-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${itl_schema}',tabname => 'itl_edw_ncbs_tb_tailbox',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);