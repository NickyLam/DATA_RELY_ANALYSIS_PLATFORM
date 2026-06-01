/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ncbs_cd_make_card_reg
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建脚本
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
                       FROM ncbs_cd_make_card_reg_bak${batch_date})
              WHERE RN = 1
 ) loop

  select count(partition_name) into v_var 
    from user_tab_partitions 
   where substr(partition_name,3) = tb.end_dt 
     and table_name = upper('ncbs_cd_make_card_reg');
  
  if v_var <> 0 then 
    execute immediate 'alter table ncbs_cd_make_card_reg drop partition p_' || tb.end_dt;
  end if;
  
    v_sql :='alter table ncbs_cd_make_card_reg add partition p_' || tb.end_dt || ' values(to_date(' || tb.end_dt || ',''yyyymmdd''))';
    
    execute immediate v_sql;

  
   -- 回插所有数据    
   
insert /*+ append */ into ${iol_schema}.ncbs_cd_make_card_reg(
            area_code -- 地区码
            ,doc_type -- 凭证类型
            ,prod_type -- 产品编号
            ,remark -- 备注
            ,user_id -- 交易柜员编号
            ,apply_no -- 申请编号
            ,batch_job_no -- 制卡文件批次号
            ,card_apply_type -- 制卡申请类型
            ,card_num -- 制卡数量
            ,company -- 法人
            ,gain_type -- 卡片领取方式
            ,lucky_card_flag -- 是否吉祥卡
            ,make_card_type -- 制卡类型
            ,make_cd_status -- 制卡状态
            ,apply_date -- 申请日期
            ,tran_timestamp -- 交易时间戳
            ,tran_branch -- 核心交易机构编号
            ,pick_type -- 选号类型
            ,receive_flag -- 签收标志
            ,make_card_date -- 制卡日期
            ,card_provider -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
            area_code -- 地区码
            ,doc_type -- 凭证类型
            ,prod_type -- 产品编号
            ,remark -- 备注
            ,user_id -- 交易柜员编号
            ,apply_no -- 申请编号
            ,batch_job_no -- 制卡文件批次号
            ,card_apply_type -- 制卡申请类型
            ,card_num -- 制卡数量
            ,company -- 法人
            ,gain_type -- 卡片领取方式
            ,lucky_card_flag -- 是否吉祥卡
            ,make_card_type -- 制卡类型
            ,make_cd_status -- 制卡状态
            ,apply_date -- 申请日期
            ,tran_timestamp -- 交易时间戳
            ,tran_branch -- 核心交易机构编号
            ,pick_type -- 选号类型
            ,receive_flag -- 签收标志
            ,make_card_date -- 制卡日期
            ,' ' as card_provider -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
from ncbs_cd_make_card_reg_bak${batch_date}
where end_dt = to_date(tb.end_dt,'yyyymmdd');
commit;

end loop;
end;
/
