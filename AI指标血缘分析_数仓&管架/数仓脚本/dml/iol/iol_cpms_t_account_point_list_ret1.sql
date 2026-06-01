/*
Purpose:    偏源模型层-增量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_cpms_t_account_point_list
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
                       FROM cpms_t_account_point_list_bak${batch_date})
              WHERE RN = 1
 ) loop

  select count(partition_name) into v_var 
    from user_tab_partitions 
   where substr(partition_name,3) = tb.end_dt 
     and table_name = 'CPMS_T_ACCOUNT_POINT_LIST';
  
  if v_var <> 0 then 
    execute immediate 'alter table cpms_t_account_point_list drop partition p_' || tb.end_dt;
  end if;
  
    v_sql :='alter table cpms_t_account_point_list add partition p_' || tb.end_dt || ' values(to_date(' || tb.end_dt || ',''yyyymmdd''))';
    
    execute immediate v_sql;
  
insert /*+ append */ into ${iol_schema}.cpms_t_account_point_list(
        id -- 
        ,branch_no -- 
        ,card_no -- 
        ,customer_no -- 
        ,custom_type -- 
        ,consume_date -- 
        ,consume_time -- 
        ,merchant_no -- 
        ,merchant_name -- 
        ,trans_name -- 
        ,trans_code -- 
        ,trans_money -- 
        ,trans_type -- P-正交易；R-冲正交易；V-撤销交易；L-撤销冲正交易
        ,operate_type -- 01消费积分；02换卡转移积分；03销卡积分清零；04开卡赠送积分；05礼品兑换；06礼品兑换撤销；07积分调整；08积分转移；09积分结转；10POS兑换；11年费兑换；12短信费兑换；13话费兑换；14消费积分冲正;15消费积分撤销;16消费积分撤销冲正;17POS兑换冲正；18POS兑换撤销；19POS兑换撤销冲正；20积分转移冲正；21积分调整冲正；22退货；23退货冲正；
        ,operate_type_name -- 01消费积分；02换卡转移积分；03销卡积分清零；04开卡赠送积分；05礼品兑换；06礼品兑换撤销；07积分调整；08积分转移；09积分结转；10POS兑换；11年费兑换；12短信费兑换；13话费兑换；14消费积分冲正;15消费积分撤销;16消费积分撤销冲正;17POS兑换冲正；18POS兑换撤销；19POS兑换撤销冲正；20积分转移冲正；21积分调整冲正；22退货；23退货冲正；
        ,trans_channel -- 
        ,sub_trans_channel -- 
        ,increase_point -- 
        ,reduce_point -- 
        ,deduc_money -- 
        ,remain_point -- 
        ,remark -- 
        ,operate_date -- 
        ,operate_time -- 
        ,operator_id -- 
        ,author_id -- 
        ,operator_org -- 
        ,operate_no -- 
        ,jrnl_no -- 
        ,tpcuid -- 
        ,uuid -- 
        ,point_time_begin -- 
        ,summary -- 
        ,expand_1 -- 
        ,expand_2 -- 
        ,expand_3 -- 
        ,expand_4 -- 
        ,expand_5 -- 
        ,is_valid -- 0-有效 1-失效
        ,last_ope_time -- 
        ,tran_seq_no_ih -- 聚合支付流水号
        ,trans_chan -- 交易渠道
        ,trade_type -- 交易类型
        ,memo -- 备注
        ,start_dt -- 开始时间
        ,end_dt -- 结束时间
        ,id_mark -- 增删标志
        ,etl_timestamp -- ETL处理时间戳
    )
select
        id -- 
        ,branch_no -- 
        ,card_no -- 
        ,customer_no -- 
        ,custom_type -- 
        ,consume_date -- 
        ,consume_time -- 
        ,merchant_no -- 
        ,merchant_name -- 
        ,trans_name -- 
        ,trans_code -- 
        ,trans_money -- 
        ,trans_type -- P-正交易；R-冲正交易；V-撤销交易；L-撤销冲正交易
        ,operate_type -- 01消费积分；02换卡转移积分；03销卡积分清零；04开卡赠送积分；05礼品兑换；06礼品兑换撤销；07积分调整；08积分转移；09积分结转；10POS兑换；11年费兑换；12短信费兑换；13话费兑换；14消费积分冲正;15消费积分撤销;16消费积分撤销冲正;17POS兑换冲正；18POS兑换撤销；19POS兑换撤销冲正；20积分转移冲正；21积分调整冲正；22退货；23退货冲正；
        ,operate_type_name -- 01消费积分；02换卡转移积分；03销卡积分清零；04开卡赠送积分；05礼品兑换；06礼品兑换撤销；07积分调整；08积分转移；09积分结转；10POS兑换；11年费兑换；12短信费兑换；13话费兑换；14消费积分冲正;15消费积分撤销;16消费积分撤销冲正;17POS兑换冲正；18POS兑换撤销；19POS兑换撤销冲正；20积分转移冲正；21积分调整冲正；22退货；23退货冲正；
        ,trans_channel -- 
        ,sub_trans_channel -- 
        ,increase_point -- 
        ,reduce_point -- 
        ,deduc_money -- 
        ,remain_point -- 
        ,remark -- 
        ,operate_date -- 
        ,operate_time -- 
        ,operator_id -- 
        ,author_id -- 
        ,operator_org -- 
        ,operate_no -- 
        ,jrnl_no -- 
        ,tpcuid -- 
        ,uuid -- 
        ,point_time_begin -- 
        ,summary -- 
        ,expand_1 -- 
        ,expand_2 -- 
        ,expand_3 -- 
        ,expand_4 -- 
        ,expand_5 -- 
        ,is_valid -- 0-有效 1-失效
        ,last_ope_time -- 
        ,' ' as tran_seq_no_ih -- 聚合支付流水号
        ,' ' as trans_chan -- 交易渠道
        ,' ' as trade_type -- 交易类型
        ,' ' as memo -- 备注
        ,start_dt -- 开始时间
        ,end_dt -- 结束时间
        ,id_mark -- 增删标志
        ,etl_timestamp -- ETL处理时间戳
from ${iol_schema}.cpms_t_account_point_list_bak${batch_date}
where end_dt = to_date(tb.end_dt,'yyyymmdd');
commit;


end loop;
end;
/
