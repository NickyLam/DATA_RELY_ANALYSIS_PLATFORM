/*
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ncbs_rb_channel_control_ret1
CreateDate: 20250619
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
                       FROM ncbs_rb_channel_control_bak${batch_date})
              WHERE RN = 1
 ) loop

  select count(partition_name) into v_var
    from user_tab_partitions
   where substr(partition_name,3) = tb.end_dt
     and table_name = upper('ncbs_rb_channel_control');

  if v_var <> 0 then
    execute immediate 'alter table ncbs_rb_channel_control drop partition p_' || tb.end_dt;
  end if;

    v_sql :='alter table ncbs_rb_channel_control add partition p_' || tb.end_dt || ' values(to_date(' || tb.end_dt || ',''yyyymmdd''))';

    execute immediate v_sql;

-- 回插所有数据

insert /*+ append */ into ${iol_schema}.ncbs_rb_channel_control (
    base_acct_no -- 交易账号/卡号
    ,client_no -- 客户编号
    ,internal_key -- 账户内部键值
    ,reference -- 交易参考号
    ,user_id -- 交易柜员编号
    ,channel_seq_no -- 全局流水号
    ,company -- 法人
    ,control_type -- 控制类型
    ,limit_level -- 限制级别
    ,narrative -- 摘要
    ,program_id -- 交易代码
    ,res_acct_range -- 限制账户范围
    ,channel -- 渠道
    ,end_date -- 结束日期
    ,last_change_date -- 最后修改日期
    ,start_date -- 开始日期
    ,tran_timestamp -- 交易时间戳
    ,auth_user_id -- 授权柜员
    ,last_change_user_id -- 最后修改柜员
    ,tran_branch -- 核心交易机构编号
    ,control_seq_no -- 控制编号
    ,control_status -- 控制状态
    ,out_sign_user_id -- 解约柜员
    ,unlost_time -- 解挂时间
    ,sign_channel -- 签约渠道
    ,sign_user_id -- 签约柜员
    ,start_date_time -- 生效时间
    ,end_date_time -- 失效时间
    ,oper_narrative -- 操作备注
    ,start_timestamp -- 加限的交易时间戳
    ,start_dt -- 开始时间
    ,end_dt -- 结束时间
    ,id_mark -- 增删标志
    ,etl_timestamp -- ETL处理时间戳
)
select
    base_acct_no as base_acct_no -- 交易账号/卡号
    ,client_no as client_no -- 客户编号
    ,internal_key as internal_key -- 账户内部键值
    ,reference as reference -- 交易参考号
    ,user_id as user_id -- 交易柜员编号
    ,channel_seq_no as channel_seq_no -- 全局流水号
    ,company as company -- 法人
    ,control_type as control_type -- 控制类型
    ,limit_level as limit_level -- 限制级别
    ,narrative as narrative -- 摘要
    ,program_id as program_id -- 交易代码
    ,res_acct_range as res_acct_range -- 限制账户范围
    ,channel as channel -- 渠道
    ,end_date as end_date -- 结束日期
    ,last_change_date as last_change_date -- 最后修改日期
    ,start_date as start_date -- 开始日期
    ,tran_timestamp as tran_timestamp -- 交易时间戳
    ,auth_user_id as auth_user_id -- 授权柜员
    ,last_change_user_id as last_change_user_id -- 最后修改柜员
    ,tran_branch as tran_branch -- 核心交易机构编号
    ,control_seq_no as control_seq_no -- 控制编号
    ,control_status as control_status -- 控制状态
    ,out_sign_user_id as out_sign_user_id -- 解约柜员
    ,unlost_time as unlost_time -- 解挂时间
    ,' ' as sign_channel -- 签约渠道
    ,' ' as sign_user_id -- 签约柜员
    ,' ' as start_date_time -- 生效时间
    ,' ' as end_date_time -- 失效时间
    ,' ' as oper_narrative -- 操作备注
    ,' ' as start_timestamp -- 加限的交易时间戳
    ,start_dt as start_dt -- 开始时间
    ,end_dt as end_dt -- 结束时间
    ,id_mark as id_mark -- 增删标志
    ,etl_timestamp as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.ncbs_rb_channel_control_bak${batch_date}
where end_dt = to_date(tb.end_dt,'yyyymmdd');

commit;

end loop;
end;
/

