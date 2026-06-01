/*
Purpose:    偏源模型层-O层拉链算法回插脚本
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ICMS_AFTERLOAN_WRITE_OFF_DUEBILL_ret1
CreateDate: 20240712_月度版本
Logs:
     SUNDEXIN 新建脚本 
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
                       FROM ICMS_AFTERLOAN_WRITE_OFF_DUEBILL_bak${batch_date})
              WHERE RN = 1
 ) loop

  select count(partition_name) into v_var 
    from user_tab_partitions 
   where substr(partition_name,3) = tb.end_dt 
     and table_name = upper('ICMS_AFTERLOAN_WRITE_OFF_DUEBILL');
  
  if v_var <> 0 then 
    execute immediate 'alter table ICMS_AFTERLOAN_WRITE_OFF_DUEBILL drop partition p_' || tb.end_dt;
  end if;
  
    v_sql :='alter table ICMS_AFTERLOAN_WRITE_OFF_DUEBILL add partition p_' || tb.end_dt || ' values(to_date(' || tb.end_dt || ',''yyyymmdd''))';
    
    execute immediate v_sql;

  
-- 回插备份表的所有数据    
   
insert /*+ append */ into ${iol_schema}.ICMS_AFTERLOAN_WRITE_OFF_DUEBILL(
            bdserialno -- 借据编号
            ,overduedays -- 逾期天数
            ,certtype -- 证件类型
            ,actlwriteoffinint -- 核销表内利息
            ,collectionnum -- 催收次数
            ,writeoffdate -- 指该贷款首次的核销日期。
            ,capitalpenaltybalance -- 罚息
            ,filepath -- 文件路径
            ,inboundbatno -- 入库批次号
            ,enddate -- 贷款逾期日
            ,actlwriteoffoffint -- 指银行贷款核销时应收回表外利息
            ,advancepayment -- 核销垫付费用
            ,certid -- 证件号码
            ,executerate -- 执行年利率
            ,termmonth -- 期限
            ,startdate -- 贷款发放日
            ,loanbalance -- 存款余额
            ,inbounddate -- 入库日期
            ,customerid -- 客户编号
            ,finabrid -- 账务机构
            ,customername -- 客户名称
            ,maturity -- 借据到期日
            ,overdueinterest -- 利息
            ,writeoffstatus -- 核销状态
            ,remark -- 备注
            ,sex -- 性别
            ,balance -- 借据余额
            ,billtype -- 借据类型（1-自营贷款2-互联网自营贷款3-互联网联合贷款）
            ,migtflag -- 迁移标志：crsrcrilcupl
            ,businesssum -- 借据金额
            ,repaytype -- 还款方式
            ,loansum -- 贷款余额
            ,businesstype -- 业务类型:1借呗二期2借呗三期3花呗4网商贷
            ,actlwriteoffloanprcp -- 指银行贷款核销时应收回本金
            ,fiveriskcla -- 五级风险分类
            ,updatedate -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
            bdserialno -- 借据编号
            ,overduedays -- 逾期天数
            ,certtype -- 证件类型
            ,actlwriteoffinint -- 核销表内利息
            ,collectionnum -- 催收次数
            ,writeoffdate -- 指该贷款首次的核销日期。
            ,capitalpenaltybalance -- 罚息
            ,filepath -- 文件路径
            ,inboundbatno -- 入库批次号
            ,enddate -- 贷款逾期日
            ,actlwriteoffoffint -- 指银行贷款核销时应收回表外利息
            ,advancepayment -- 核销垫付费用
            ,certid -- 证件号码
            ,executerate -- 执行年利率
            ,termmonth -- 期限
            ,startdate -- 贷款发放日
            ,loanbalance -- 存款余额
            ,inbounddate -- 入库日期
            ,customerid -- 客户编号
            ,finabrid -- 账务机构
            ,customername -- 客户名称
            ,maturity -- 借据到期日
            ,overdueinterest -- 利息
            ,writeoffstatus -- 核销状态
            ,remark -- 备注
            ,sex -- 性别
            ,balance -- 借据余额
            ,billtype -- 借据类型（1-自营贷款2-互联网自营贷款3-互联网联合贷款）
            ,migtflag -- 迁移标志：crsrcrilcupl
            ,businesssum -- 借据金额
            ,repaytype -- 还款方式
            ,loansum -- 贷款余额
            ,businesstype -- 业务类型:1借呗二期2借呗三期3花呗4网商贷
            ,actlwriteoffloanprcp -- 指银行贷款核销时应收回本金
            ,fiveriskcla -- 五级风险分类
            ,to_date('00010101','yyyymmdd') as updatedate -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
from ${iol_schema}.ICMS_AFTERLOAN_WRITE_OFF_DUEBILL_bak${batch_date}
where end_dt = to_date(tb.end_dt,'yyyymmdd');
commit;


end loop;
end;
/
