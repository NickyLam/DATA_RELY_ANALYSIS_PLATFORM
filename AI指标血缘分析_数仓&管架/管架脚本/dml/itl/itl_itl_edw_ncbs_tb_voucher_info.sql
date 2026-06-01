/*
Purpose:    技术缓冲层脚本，把数据文件加载到目标表的当天分区中。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd itl_itl_edw_ncbs_tb_voucher_info
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
alter table ${itl_schema}.itl_edw_ncbs_tb_voucher_info drop partition p_${retain_day};
alter table ${itl_schema}.itl_edw_ncbs_tb_voucher_info drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${itl_schema}.itl_edw_ncbs_tb_voucher_info add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${itl_schema}.itl_edw_ncbs_tb_voucher_info partition for (to_date('${batch_date}','yyyymmdd')) (
    branch -- 机构编号
    ,ccy -- 币种
    ,doc_type -- 凭证类型
    ,remark -- 备注
    ,voucher_status -- 凭证状态
    ,company -- 法人
    ,prefix -- 前缀
    ,tailbox_id -- 尾箱代号
    ,voucher_id -- 凭证主键
    ,voucher_sum -- 凭证合计数
    ,tran_timestamp -- 交易时间戳
    ,update_date -- 更新日期
    ,last_user_id -- 上一柜员id
    ,tran_amt -- 交易金额
    ,voucher_end_no -- 凭证终止号码
    ,voucher_start_no -- 凭证起始号码
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间
)
select
    nvl(trim(branch), ' ') as branch -- 机构编号
    ,nvl(trim(ccy), ' ') as ccy -- 币种
    ,nvl(trim(doc_type), ' ') as doc_type -- 凭证类型
    ,nvl(trim(remark), ' ') as remark -- 备注
    ,nvl(trim(voucher_status), ' ') as voucher_status -- 凭证状态
    ,nvl(trim(company), ' ') as company -- 法人
    ,nvl(trim(prefix), ' ') as prefix -- 前缀
    ,nvl(trim(tailbox_id), ' ') as tailbox_id -- 尾箱代号
    ,nvl(trim(voucher_id), ' ') as voucher_id -- 凭证主键
    ,nvl(trim(voucher_sum), 0) as voucher_sum -- 凭证合计数
    ,nvl(trim(tran_timestamp), ' ') as tran_timestamp -- 交易时间戳
    ,nvl(update_date, to_date('00010101', 'yyyymmdd')) as update_date -- 更新日期
    ,nvl(trim(last_user_id), ' ') as last_user_id -- 上一柜员id
    ,nvl(trim(tran_amt), 0) as tran_amt -- 交易金额
    ,nvl(trim(voucher_end_no), ' ') as voucher_end_no -- 凭证终止号码
    ,nvl(trim(voucher_start_no), ' ') as voucher_start_no -- 凭证起始号码
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${msl_schema}.msl_edw_ncbs_tb_voucher_info
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')
 ;
commit;

-- 3 table grant
whenever sqlerror exit sql.sqlcode;
grant select on ${itl_schema}.itl_edw_ncbs_tb_voucher_info to ${iol_schema};

-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${itl_schema}',tabname => 'itl_edw_ncbs_tb_voucher_info',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);