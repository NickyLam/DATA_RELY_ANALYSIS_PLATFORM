/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ppps_e_contract
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
                       FROM ppps_e_contract_bak${batch_date})
              WHERE RN = 1
 ) loop

  select count(partition_name) into v_var 
    from user_tab_partitions 
   where substr(partition_name,3) = tb.end_dt 
     and table_name = upper('ppps_e_contract');
  
  if v_var <> 0 then 
    execute immediate 'alter table ppps_e_contract drop partition p_' || tb.end_dt;
  end if;
  
    v_sql :='alter table ppps_e_contract add partition p_' || tb.end_dt || ' values(to_date(' || tb.end_dt || ',''yyyymmdd''))';
    
    execute immediate v_sql;

  
   -- 回插所有数据    
   
insert /*+ append */ into ${iol_schema}.ppps_e_contract(
            id -- 自增主键
            ,sgn_no -- 签约协议号
            ,issr_id -- 发起方所属机构编号
            ,sgn_date -- 签约日期:yyyyMMdd
            ,sgn_time -- 签约时间:HHmmss
            ,sgn_status -- 签约状态：0-正常（成功），1-失败，2-已解约，3-过期
            ,sgn_acct_issr_id -- 签约人银行账户所属机构标识
            ,sgn_acct_tp -- 签约账户类型:00-个人借记，01-个人贷记，02-个人准待机，03-个人支付，04-单位支付，05-对公账户，06-备付金，07-存折
            ,sgn_acct_id_de -- 签约账号
            ,sgn_acct_nm_de -- 签约账户户名
            ,sgn_acct_lvl -- 签约账户等级:0-缺省，1-I类户，2-II类户，3-III类户
            ,id_tp -- 证件类型
            ,id_no_de -- 证件号码
            ,mob_no_de -- 手机号
            ,instg_id -- 支付账户所属机构标识
            ,instg_acct_de -- 签约人支付账号
            ,expire_date -- 协议失效日期
            ,insert_time -- 创建时间
            ,update_time -- 最后更新时间
            ,remark -- 备注信息
            ,enabled_state -- 启用状态（ACTIVE-正常 INACTIVE-失效）
            ,pty_id -- 客户号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
            id -- 自增主键
            ,sgn_no -- 签约协议号
            ,issr_id -- 发起方所属机构编号
            ,sgn_date -- 签约日期:yyyyMMdd
            ,sgn_time -- 签约时间:HHmmss
            ,sgn_status -- 签约状态：0-正常（成功），1-失败，2-已解约，3-过期
            ,sgn_acct_issr_id -- 签约人银行账户所属机构标识
            ,sgn_acct_tp -- 签约账户类型:00-个人借记，01-个人贷记，02-个人准待机，03-个人支付，04-单位支付，05-对公账户，06-备付金，07-存折
            ,sgn_acct_id_de -- 签约账号
            ,sgn_acct_nm_de -- 签约账户户名
            ,sgn_acct_lvl -- 签约账户等级:0-缺省，1-I类户，2-II类户，3-III类户
            ,id_tp -- 证件类型
            ,id_no_de -- 证件号码
            ,mob_no_de -- 手机号
            ,instg_id -- 支付账户所属机构标识
            ,instg_acct_de -- 签约人支付账号
            ,expire_date -- 协议失效日期
            ,insert_time -- 创建时间
            ,update_time -- 最后更新时间
            ,remark -- 备注信息
            ,enabled_state -- 启用状态（ACTIVE-正常 INACTIVE-失效）
            ,' ' as pty_id -- 客户号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
from ppps_e_contract_bak${batch_date}
where end_dt = to_date(tb.end_dt,'yyyymmdd');
commit;

end loop;
end;
/
