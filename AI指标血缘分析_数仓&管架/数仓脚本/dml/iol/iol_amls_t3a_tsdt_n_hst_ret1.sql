/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_amls_t3a_tsdt_n_hst
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
                       FROM amls_t3a_tsdt_n_hst_bak${batch_date})
              WHERE RN = 1
 ) loop

  select count(partition_name) into v_var 
    from user_tab_partitions 
   where substr(partition_name,3) = tb.end_dt 
     and table_name = upper('amls_t3a_tsdt_n_hst');
  
  if v_var <> 0 then 
    execute immediate 'alter table amls_t3a_tsdt_n_hst drop partition p_' || tb.end_dt;
  end if;
  
    v_sql :='alter table amls_t3a_tsdt_n_hst add partition p_' || tb.end_dt || ' values(to_date(' || tb.end_dt || ',''yyyymmdd''))';
    
    execute immediate v_sql;

  
   -- 回插所有数据    
   
insert /*+ append */ into ${iol_schema}.amls_t3a_tsdt_n_hst(
            rpt_id -- 报告编号
            ,stat_dt -- 数据日期
            ,cbif_seq -- 客户序号
            ,crcd -- 大额交易特征代码
            ,tsdt_seq -- 交易序号
            ,atif_seq -- 账户序号
            ,htcr_seq -- 特征序号
            ,finc -- 金融机构网点代码
            ,rlfc -- 金融机构与客户的关系
            ,tbnm -- 交易代办人姓名
            ,tbit -- 交易代办人身份证件/证明文件类型
            ,tb_oitp -- 其他身份证件/证明文件类型
            ,tbid -- 交易代办人身份证件/证明文件号码
            ,tbnt -- 交易代办人国籍
            ,tstm -- 交易时间
            ,trcd -- 交易发生地
            ,ticd -- 业务标识号
            ,rpmt -- 收付款方匹配号类型
            ,rpmn -- 收付款方匹配号
            ,tstp -- 交易方式
            ,octt -- 非柜台交易方式
            ,ooct -- 其他非柜台交易方式
            ,ocec -- 非柜台交易方式的设备代码
            ,bptc -- 银行与支付机构之间的业务交易编码
            ,tsct -- 涉外收支交易分类与代码(参见表t1p_tsct)
            ,tsdr -- 资金收付标志
            ,crpp -- 资金用途
            ,crtp -- 交易币种
            ,crat -- 交易金额
            ,cfin -- 对方金融机构网点名称
            ,cfct -- 对方金融机构网点代码类型
            ,cfic -- 对方金融机构网点代码
            ,cfrc -- 对方金融机构网点行政区划代码
            ,tcnm -- 交易对手姓名/名称
            ,tcit -- 交易对手身份证件/证明文件类型
            ,tc_oitp -- 其他身份证件/证明文件类型
            ,tcid -- 交易对手身份证件/证明文件号码
            ,tcat -- 交易对手账户类型
            ,tcac -- 交易对手账号
            ,rotf1 -- 交易信息备注1
            ,rotf2 -- 交易信息备注2
            ,bh_valid -- 大额验证（参见[字典:AML0041]）
            ,cust_id -- 客户编号
            ,cust_type -- 客户类型（参见[字典:AML0030]）
            ,tr_dt -- 交易日期
            ,tr_org_id -- 交易机构
            ,is_cash -- 现转标志（参见[字典:AML0034]）
            ,is_local_curr -- 本外币标志（参见[字典:AML0015]）
            ,tr_amt -- 原币交易金额
            ,debit_credit -- 借贷标志（参见[字典:AML0035]）
            ,acct_id -- 账号
            ,main_acct_id -- 主客户账号
            ,card_no -- 银行卡卡号
            ,rpdt -- 报告生成日期
            ,err_type -- 错误类型
            ,pbc_rcpt_tm -- 人行回执时间
            ,crmb -- 交易金额（折人民币）
            ,cusd -- 交易金额（折美元）
            ,ccif_seq -- 交易客户序号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
            rpt_id -- 报告编号
            ,stat_dt -- 数据日期
            ,cbif_seq -- 客户序号
            ,crcd -- 大额交易特征代码
            ,tsdt_seq -- 交易序号
            ,atif_seq -- 账户序号
            ,htcr_seq -- 特征序号
            ,finc -- 金融机构网点代码
            ,rlfc -- 金融机构与客户的关系
            ,tbnm -- 交易代办人姓名
            ,tbit -- 交易代办人身份证件/证明文件类型
            ,tb_oitp -- 其他身份证件/证明文件类型
            ,tbid -- 交易代办人身份证件/证明文件号码
            ,tbnt -- 交易代办人国籍
            ,tstm -- 交易时间
            ,trcd -- 交易发生地
            ,ticd -- 业务标识号
            ,rpmt -- 收付款方匹配号类型
            ,rpmn -- 收付款方匹配号
            ,tstp -- 交易方式
            ,octt -- 非柜台交易方式
            ,ooct -- 其他非柜台交易方式
            ,ocec -- 非柜台交易方式的设备代码
            ,bptc -- 银行与支付机构之间的业务交易编码
            ,tsct -- 涉外收支交易分类与代码(参见表t1p_tsct)
            ,tsdr -- 资金收付标志
            ,crpp -- 资金用途
            ,crtp -- 交易币种
            ,crat -- 交易金额
            ,cfin -- 对方金融机构网点名称
            ,cfct -- 对方金融机构网点代码类型
            ,cfic -- 对方金融机构网点代码
            ,cfrc -- 对方金融机构网点行政区划代码
            ,tcnm -- 交易对手姓名/名称
            ,tcit -- 交易对手身份证件/证明文件类型
            ,tc_oitp -- 其他身份证件/证明文件类型
            ,tcid -- 交易对手身份证件/证明文件号码
            ,tcat -- 交易对手账户类型
            ,tcac -- 交易对手账号
            ,rotf1 -- 交易信息备注1
            ,rotf2 -- 交易信息备注2
            ,bh_valid -- 大额验证（参见[字典:AML0041]）
            ,cust_id -- 客户编号
            ,cust_type -- 客户类型（参见[字典:AML0030]）
            ,tr_dt -- 交易日期
            ,tr_org_id -- 交易机构
            ,is_cash -- 现转标志（参见[字典:AML0034]）
            ,is_local_curr -- 本外币标志（参见[字典:AML0015]）
            ,tr_amt -- 原币交易金额
            ,debit_credit -- 借贷标志（参见[字典:AML0035]）
            ,acct_id -- 账号
            ,main_acct_id -- 主客户账号
            ,card_no -- 银行卡卡号
            ,rpdt -- 报告生成日期
            ,err_type -- 错误类型
            ,pbc_rcpt_tm -- 人行回执时间
            ,crmb -- 交易金额（折人民币）
            ,cusd -- 交易金额（折美元）
            ,ccif_seq -- 交易客户序号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
from ${iol_schema}.amls_t3a_tsdt_n_hst_bak${batch_date}
where end_dt = to_date(tb.end_dt,'yyyymmdd');
commit;

end loop;
end;
/
