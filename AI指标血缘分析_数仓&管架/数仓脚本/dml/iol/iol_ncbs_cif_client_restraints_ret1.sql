/*
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ncbs_cif_client_restraints_ret1
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
                       FROM ncbs_cif_client_restraints_bak${batch_date})
              WHERE RN = 1
 ) loop

  select count(partition_name) into v_var
    from user_tab_partitions
   where substr(partition_name,3) = tb.end_dt
     and table_name = upper('ncbs_cif_client_restraints');

  if v_var <> 0 then
    execute immediate 'alter table ncbs_cif_client_restraints drop partition p_' || tb.end_dt;
  end if;

    v_sql :='alter table ncbs_cif_client_restraints add partition p_' || tb.end_dt || ' values(to_date(' || tb.end_dt || ',''yyyymmdd''))';

    execute immediate v_sql;

-- 回插所有数据

insert /*+ append */ into ${iol_schema}.ncbs_cif_client_restraints (
    res_seq_no -- 限制编号
    ,restraint_type -- 限制类型
    ,source_type -- 渠道编号
    ,tran_date -- 交易日期
    ,tran_branch -- 核心交易机构编号
    ,maintain_type -- 维护方式
    ,client_no -- 客户编号
    ,start_date -- 开始日期
    ,term -- 存期
    ,term_type -- 期限单位
    ,end_date -- 结束日期
    ,restraints_status -- 限制状态
    ,narrative -- 摘要
    ,user_id -- 交易柜员编号
    ,auth_user_id -- 授权柜员
    ,last_change_date -- 最后修改日期
    ,last_change_user_id -- 最后修改柜员
    ,tran_timestamp -- 交易时间戳
    ,company -- 法人
    ,sign_user_id -- 签约柜员
    ,out_sign_user_id -- 解约柜员
    ,sign_channel -- 签约渠道
    ,unlost_time -- 解挂时间
    ,oper_narrative -- 操作备注
    ,start_timestamp -- 加限的交易时间戳
    ,actual_effect_time -- 实际生效时间
    ,start_dt -- 开始时间
    ,end_dt -- 结束时间
    ,id_mark -- 增删标志
    ,etl_timestamp -- ETL处理时间戳
)
select
    res_seq_no as res_seq_no -- 限制编号
    ,restraint_type as restraint_type -- 限制类型
    ,source_type as source_type -- 渠道编号
    ,tran_date as tran_date -- 交易日期
    ,tran_branch as tran_branch -- 核心交易机构编号
    ,maintain_type as maintain_type -- 维护方式
    ,client_no as client_no -- 客户编号
    ,start_date as start_date -- 开始日期
    ,term as term -- 存期
    ,term_type as term_type -- 期限单位
    ,end_date as end_date -- 结束日期
    ,restraints_status as restraints_status -- 限制状态
    ,narrative as narrative -- 摘要
    ,user_id as user_id -- 交易柜员编号
    ,auth_user_id as auth_user_id -- 授权柜员
    ,last_change_date as last_change_date -- 最后修改日期
    ,last_change_user_id as last_change_user_id -- 最后修改柜员
    ,tran_timestamp as tran_timestamp -- 交易时间戳
    ,company as company -- 法人
    ,sign_user_id as sign_user_id -- 签约柜员
    ,out_sign_user_id as out_sign_user_id -- 解约柜员
    ,sign_channel as sign_channel -- 签约渠道
    ,unlost_time as unlost_time -- 解挂时间
    ,' ' as oper_narrative -- 操作备注
    ,' ' as start_timestamp -- 加限的交易时间戳
    ,' ' as actual_effect_time -- 实际生效时间
    ,start_dt as start_dt -- 开始时间
    ,end_dt as end_dt -- 结束时间
    ,id_mark as id_mark -- 增删标志
    ,etl_timestamp as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.ncbs_cif_client_restraints_bak${batch_date}
where end_dt = to_date(tb.end_dt,'yyyymmdd');

commit;

end loop;
end;
/

