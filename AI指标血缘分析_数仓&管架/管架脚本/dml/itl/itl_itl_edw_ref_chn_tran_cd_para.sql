/*
Purpose:    技术缓冲层脚本，把数据文件加载到目标表的当天分区中。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd itl_itl_edw_ref_chn_tran_cd_para
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
alter table ${itl_schema}.itl_edw_ref_chn_tran_cd_para drop partition p_${retain_day};
alter table ${itl_schema}.itl_edw_ref_chn_tran_cd_para drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${itl_schema}.itl_edw_ref_chn_tran_cd_para add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${itl_schema}.itl_edw_ref_chn_tran_cd_para partition for (to_date('${batch_date}','yyyymmdd')) (
    chn_cd -- 渠道代码
    ,tran_cd -- 交易代码
    ,intnal_tran_cd -- 内部交易代码
    ,msg_type_cd -- 报文类型代码
    ,tran_proc_cd -- 交易处理代码
    ,tran_name -- 交易名称
    ,bank_int_proc_cd -- 行内处理代码
    ,obank_proc_cd -- 他行处理代码
    ,status_cd -- 状态代码
    ,fobid_flg -- 禁用标志
    ,deflt_memo_cd -- 默认摘要代码
    ,memo_name -- 摘要名称
    ,update_dt -- 更新日期
    --,src_table_name -- 源表名称
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间
)
select
    nvl(trim(chn_cd), ' ') as chn_cd -- 渠道代码
    ,nvl(trim(tran_cd), ' ') as tran_cd -- 交易代码
    ,nvl(trim(intnal_tran_cd), ' ') as intnal_tran_cd -- 内部交易代码
    ,nvl(trim(msg_type_cd), ' ') as msg_type_cd -- 报文类型代码
    ,nvl(trim(tran_proc_cd), ' ') as tran_proc_cd -- 交易处理代码
    ,nvl(trim(tran_name), ' ') as tran_name -- 交易名称
    ,nvl(trim(bank_int_proc_cd), ' ') as bank_int_proc_cd -- 行内处理代码
    ,nvl(trim(obank_proc_cd), ' ') as obank_proc_cd -- 他行处理代码
    ,nvl(trim(status_cd), ' ') as status_cd -- 状态代码
    ,nvl(trim(fobid_flg), ' ') as fobid_flg -- 禁用标志
    ,nvl(trim(deflt_memo_cd), ' ') as deflt_memo_cd -- 默认摘要代码
    ,nvl(trim(memo_name), ' ') as memo_name -- 摘要名称
    ,nvl(update_dt, to_date('00010101', 'yyyymmdd')) as update_dt -- 更新日期
    --,nvl(trim(src_table_name), ' ') as src_table_name -- 源表名称
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${msl_schema}.msl_edw_ref_chn_tran_cd_para
where etl_dt = to_date('${batch_date}','yyyymmdd')
 ;
commit;

-- 3 table grant
whenever sqlerror exit sql.sqlcode;
grant select on ${itl_schema}.itl_edw_ref_chn_tran_cd_para to ${iol_schema};

-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${itl_schema}',tabname => 'itl_edw_ref_chn_tran_cd_para',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);