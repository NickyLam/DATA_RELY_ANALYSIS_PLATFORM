/*
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_tbps_cpr_ecomplex_batch_flow_ret1
CreateDate: 20250516
*/

set timing on
-- 1.1 alter parallel
alter session force parallel query parallel 3;
alter session force parallel dml parallel 3;

declare
  v_var    number(3)  :=0;
  v_sql    varchar2(1000);

begin
  for tb in (SELECT TO_CHAR(END_DT, 'yyyymmdd') as end_dt
               FROM (SELECT END_DT,
                            ROW_NUMBER() OVER(PARTITION BY END_DT ORDER BY END_DT) RN
                       FROM tbps_cpr_ecomplex_batch_flow_bak${batch_date})
              WHERE RN = 1
 ) loop

  select count(partition_name) into v_var
    from user_tab_partitions
   where substr(partition_name,3) = tb.end_dt
     and table_name = upper('tbps_cpr_ecomplex_batch_flow');

  if v_var <> 0 then
    execute immediate 'alter table tbps_cpr_ecomplex_batch_flow drop partition p_' || tb.end_dt;
  end if;

    v_sql :='alter table tbps_cpr_ecomplex_batch_flow add partition p_' || tb.end_dt || ' values(to_date(' || tb.end_dt || ',''yyyymmdd''))';

    execute immediate v_sql;

-- 回插所有数据

insert /*+ append */ into ${iol_schema}.tbps_cpr_ecomplex_batch_flow (
    ebf_batchno -- 批次号
    ,ebf_batchdate -- 提交日期
    ,ebf_upload_flowno -- 文件上传流水号
    ,ebf_flowno -- 提交交易流水号
    ,ebf_ecifno -- 客户号
    ,ebf_userno -- 用户序号
    ,ebf_accno -- 账户序号
    ,ebf_showflag -- 显示明细标识
    ,ebf_totalcount -- 总笔数
    ,ebf_totalamount -- 总金额
    ,ebf_transdate -- 交易日期
    ,ebf_transtime -- 交易时间
    ,ebf_filename -- 文件名
    ,ebf_checkcount -- 检查条数
    ,ebf_checkerrorcount -- 错误条数
    ,ebf_checkstatus -- 校验状态（0-校验成功，1-校验失败，2-校验中）
    ,ebf_batchstate -- 批次状态
    ,ebf_operater -- 操作类型:1-退税
    ,start_dt -- 开始时间
    ,end_dt -- 结束时间
    ,id_mark -- 增删标志
    ,etl_timestamp -- ETL处理时间戳
)
select
    ebf_batchno as ebf_batchno -- 批次号
    ,ebf_batchdate as ebf_batchdate -- 提交日期
    ,ebf_upload_flowno as ebf_upload_flowno -- 文件上传流水号
    ,ebf_flowno as ebf_flowno -- 提交交易流水号
    ,ebf_ecifno as ebf_ecifno -- 客户号
    ,ebf_userno as ebf_userno -- 用户序号
    ,ebf_accno as ebf_accno -- 账户序号
    ,ebf_showflag as ebf_showflag -- 显示明细标识
    ,ebf_totalcount as ebf_totalcount -- 总笔数
    ,ebf_totalamount as ebf_totalamount -- 总金额
    ,ebf_transdate as ebf_transdate -- 交易日期
    ,ebf_transtime as ebf_transtime -- 交易时间
    ,ebf_filename as ebf_filename -- 文件名
    ,ebf_checkcount as ebf_checkcount -- 检查条数
    ,ebf_checkerrorcount as ebf_checkerrorcount -- 错误条数
    ,ebf_checkstatus as ebf_checkstatus -- 校验状态（0-校验成功，1-校验失败，2-校验中）
    ,ebf_batchstate as ebf_batchstate -- 批次状态
    ,' ' as ebf_operater -- 操作类型:1-退税
    ,start_dt as start_dt -- 开始时间
    ,end_dt as end_dt -- 结束时间
    ,id_mark as id_mark -- 增删标志
    ,etl_timestamp as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.tbps_cpr_ecomplex_batch_flow_bak${batch_date}
where end_dt = to_date(tb.end_dt,'yyyymmdd');

commit;

end loop;
end;
/

