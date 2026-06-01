/*
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_acct_transaction_ret1
CreateDate: 20250523
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
                       FROM icms_acct_transaction_bak${batch_date})
              WHERE RN = 1
 ) loop

  select count(partition_name) into v_var
    from user_tab_partitions
   where substr(partition_name,3) = tb.end_dt
     and table_name = upper('icms_acct_transaction');

  if v_var <> 0 then
    execute immediate 'alter table icms_acct_transaction drop partition p_' || tb.end_dt;
  end if;

    v_sql :='alter table icms_acct_transaction add partition p_' || tb.end_dt || ' values(to_date(' || tb.end_dt || ',''yyyymmdd''))';

    execute immediate v_sql;

-- 回插所有数据

insert /*+ append */ into ${iol_schema}.icms_acct_transaction (
    serialno -- 交易流水号
    ,parenttransserialno -- 关联交易流水号
    ,transcode -- 交易代码
    ,relativeobjecttype -- 关联对象类型
    ,relativeobjectno -- 关联对象编号
    ,documenttype -- 单据类型
    ,documentno -- 单据流水号
    ,channelid -- 交易渠道
    ,occurdate -- 交易操作日期
    ,occurtime -- 交易时间
    ,transdate -- 交易日期
    ,transstatus -- 交易状态(CodeNo:TransStatus)
    ,inputorgid -- 录入机构
    ,inputuserid -- 录入用户
    ,inputtime -- 录入日期
    ,remark -- 备注
    ,log -- 其他日志
    ,fallbacktransserialno -- 回退交易流水
    ,tellerserialno -- 柜员流水号
    ,transsum -- 交易金额
    ,cnsmrsrlno -- 消费方流水号(调用还款交易接口时的消费方流水号)
    ,accountingserialno -- 唯一核心记账流水号
    ,transtype -- 转让类型(福费廷转让使用)
    ,transoccurtype -- 交易发生类型
    ,completeflag -- 数据录入完整性标识
    ,migtflag -- 迁移标志：crs rcr ilc upl
    ,graceinterestflag -- 是否宽限利息
    ,graceprincipalflag -- 是否宽限本金
    ,repayreason -- 提前还款说明
    ,repaysource -- 提前还款资金来源
    ,whethertorestructuretheloan -- 是否重组贷款
    ,updatedate -- 更新时间
    ,repayreasontype -- 提前还款原因
    ,start_dt -- 开始时间
    ,end_dt -- 结束时间
    ,id_mark -- 增删标志
    ,etl_timestamp -- ETL处理时间戳
)
select
    serialno as serialno -- 交易流水号
    ,parenttransserialno as parenttransserialno -- 关联交易流水号
    ,transcode as transcode -- 交易代码
    ,relativeobjecttype as relativeobjecttype -- 关联对象类型
    ,relativeobjectno as relativeobjectno -- 关联对象编号
    ,documenttype as documenttype -- 单据类型
    ,documentno as documentno -- 单据流水号
    ,channelid as channelid -- 交易渠道
    ,occurdate as occurdate -- 交易操作日期
    ,occurtime as occurtime -- 交易时间
    ,transdate as transdate -- 交易日期
    ,transstatus as transstatus -- 交易状态(CodeNo:TransStatus)
    ,inputorgid as inputorgid -- 录入机构
    ,inputuserid as inputuserid -- 录入用户
    ,inputtime as inputtime -- 录入日期
    ,remark as remark -- 备注
    ,log as log -- 其他日志
    ,fallbacktransserialno as fallbacktransserialno -- 回退交易流水
    ,tellerserialno as tellerserialno -- 柜员流水号
    ,transsum as transsum -- 交易金额
    ,cnsmrsrlno as cnsmrsrlno -- 消费方流水号(调用还款交易接口时的消费方流水号)
    ,accountingserialno as accountingserialno -- 唯一核心记账流水号
    ,transtype as transtype -- 转让类型(福费廷转让使用)
    ,transoccurtype as transoccurtype -- 交易发生类型
    ,completeflag as completeflag -- 数据录入完整性标识
    ,migtflag as migtflag -- 迁移标志：crs rcr ilc upl
    ,graceinterestflag as graceinterestflag -- 是否宽限利息
    ,graceprincipalflag as graceprincipalflag -- 是否宽限本金
    ,' ' as repayreason -- 提前还款说明
    ,' ' as repaysource -- 提前还款资金来源
    ,' ' as whethertorestructuretheloan -- 是否重组贷款
    ,to_date('00010101','yyyymmdd') as updatedate -- 更新时间
    ,' ' as repayreasontype -- 提前还款原因
    ,start_dt as start_dt -- 开始时间
    ,end_dt as end_dt -- 结束时间
    ,id_mark as id_mark -- 增删标志
    ,etl_timestamp as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.icms_acct_transaction_bak${batch_date}
where end_dt = to_date(tb.end_dt,'yyyymmdd');

commit;

end loop;
end;
/

