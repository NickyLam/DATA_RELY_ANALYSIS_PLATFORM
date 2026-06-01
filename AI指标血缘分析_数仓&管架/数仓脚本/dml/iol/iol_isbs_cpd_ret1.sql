/*
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_isbs_cpd_ret1
CreateDate: 20250115
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
                       FROM isbs_cpd_bak${batch_date})
              WHERE RN = 1
 ) loop

  select count(partition_name) into v_var
    from user_tab_partitions
   where substr(partition_name,3) = tb.end_dt
     and table_name = upper('isbs_cpd');

  if v_var <> 0 then
    execute immediate 'alter table isbs_cpd drop partition p_' || tb.end_dt;
  end if;

    v_sql :='alter table isbs_cpd add partition p_' || tb.end_dt || ' values(to_date(' || tb.end_dt || ',''yyyymmdd''))';

    execute immediate v_sql;

-- 回插所有数据

insert /*+ append */ into ${iol_schema}.isbs_cpd (
    inr -- 唯一id
    ,ownref -- 交易参考号
    ,nam -- 交易描述
    ,pyeptyinr -- 收款人的inr
    ,pyeptainr -- 收款人的地址
    ,pyenam -- 收款人的描述
    ,pyeref -- 收款人的参考号
    ,pybptyinr -- 付款银行的inr
    ,pybptainr -- 付款银行地址的inr
    ,pybnam -- 付款银行名称
    ,pybref -- 付款银行参考号
    ,orcptyinr -- 汇款人ptyinr
    ,orcptainr -- 汇款人ptainr
    ,orcnam -- 汇款人名称
    ,orcref -- 汇款人参考号
    ,oriptyinr -- 汇款行ptyinr
    ,oriptainr -- 汇款行ptainr
    ,orinam -- 汇款行名称
    ,oriref -- 汇款行参考号
    ,valdat -- 起息日
    ,opndat -- 交易开始时间
    ,clsdat -- 交易关闭时间
    ,chato -- 费用
    ,credat -- 建立日期
    ,ownusr -- 操作用户
    ,ver -- 版本号
    ,detchgcod -- 详细费用
    ,paytyp -- 付款类型
    ,stagod -- 货物代码
    ,stacty -- 国家代码
    ,etyextkey -- 实体关键字
    ,sysno -- 清算编号
    ,othbch -- 所属行
    ,gors -- 收款对象
    ,feecur -- 国外费用币种
    ,feeamt -- 国外费用金额
    ,trntyp -- 汇款性质
    ,paytype -- 汇款方式
    ,paydat -- 付款日期
    ,clityp -- 客户类型
    ,trdint -- 结汇类型
    ,curf33b -- 原始币种
    ,cur71f -- 发报行扣费币种
    ,amt71f -- 发报行扣费金额
    ,amtf33b -- 原始金额
    ,f36 -- 汇率
    ,f23e -- 指令代码
    ,f23b -- 银行操作码
    ,trdout -- 售汇类型
    ,swftyp -- 报文类型
    ,trdinr -- trd表inr
    ,rel21 -- 参考号
    ,branchinr -- 所属机构号
    ,bchkeyinr -- 经办机构号
    ,accmod -- 处理类型
    ,sztyp -- 收支类型
    ,sndbanref -- 发报行原始编号
    ,orcact -- 汇款人帐号
    ,pyeact -- 收款人帐号
    ,canflg -- 退汇标志
    ,nraflg -- nra标志
    ,qsqdbh -- 清算渠道
    ,zjcflg -- 跨境资金池标识
    ,edtyp -- 资金池业务类型
    ,basamt -- 资金池业务本金
    ,intamt -- 资金池业务利息
    ,stzfref -- 受托支付编号
    ,duebillno -- 受托支付出账借据号
    ,gpiflg -- gpi业务标识
    ,acstyp -- gpi mt199报文反馈码
    ,qufflg -- 询价标识（线上汇款业务是否有做过询价）
    ,feeacc -- 扣费账号（线上汇款业务的费用承担方为our时带入客户扣费账号）
    ,resno -- 限制编号
    ,isbxt -- 是否北向通
    ,bxtamt -- 金额
    ,bxtsamt -- 北向通金额
    ,iskds -- 是否跨境电商标识
    ,sbflg -- 申报标识
    ,start_dt -- 开始时间
    ,end_dt -- 结束时间
    ,id_mark -- 增删标志
    ,etl_timestamp -- ETL处理时间戳
)
select
    inr as inr -- 唯一id
    ,ownref as ownref -- 交易参考号
    ,nam as nam -- 交易描述
    ,pyeptyinr as pyeptyinr -- 收款人的inr
    ,pyeptainr as pyeptainr -- 收款人的地址
    ,pyenam as pyenam -- 收款人的描述
    ,pyeref as pyeref -- 收款人的参考号
    ,pybptyinr as pybptyinr -- 付款银行的inr
    ,pybptainr as pybptainr -- 付款银行地址的inr
    ,pybnam as pybnam -- 付款银行名称
    ,pybref as pybref -- 付款银行参考号
    ,orcptyinr as orcptyinr -- 汇款人ptyinr
    ,orcptainr as orcptainr -- 汇款人ptainr
    ,orcnam as orcnam -- 汇款人名称
    ,orcref as orcref -- 汇款人参考号
    ,oriptyinr as oriptyinr -- 汇款行ptyinr
    ,oriptainr as oriptainr -- 汇款行ptainr
    ,orinam as orinam -- 汇款行名称
    ,oriref as oriref -- 汇款行参考号
    ,valdat as valdat -- 起息日
    ,opndat as opndat -- 交易开始时间
    ,clsdat as clsdat -- 交易关闭时间
    ,chato as chato -- 费用
    ,credat as credat -- 建立日期
    ,ownusr as ownusr -- 操作用户
    ,ver as ver -- 版本号
    ,detchgcod as detchgcod -- 详细费用
    ,paytyp as paytyp -- 付款类型
    ,stagod as stagod -- 货物代码
    ,stacty as stacty -- 国家代码
    ,etyextkey as etyextkey -- 实体关键字
    ,sysno as sysno -- 清算编号
    ,othbch as othbch -- 所属行
    ,gors as gors -- 收款对象
    ,feecur as feecur -- 国外费用币种
    ,feeamt as feeamt -- 国外费用金额
    ,trntyp as trntyp -- 汇款性质
    ,paytype as paytype -- 汇款方式
    ,paydat as paydat -- 付款日期
    ,clityp as clityp -- 客户类型
    ,trdint as trdint -- 结汇类型
    ,curf33b as curf33b -- 原始币种
    ,cur71f as cur71f -- 发报行扣费币种
    ,amt71f as amt71f -- 发报行扣费金额
    ,amtf33b as amtf33b -- 原始金额
    ,f36 as f36 -- 汇率
    ,f23e as f23e -- 指令代码
    ,f23b as f23b -- 银行操作码
    ,trdout as trdout -- 售汇类型
    ,swftyp as swftyp -- 报文类型
    ,trdinr as trdinr -- trd表inr
    ,rel21 as rel21 -- 参考号
    ,branchinr as branchinr -- 所属机构号
    ,bchkeyinr as bchkeyinr -- 经办机构号
    ,accmod as accmod -- 处理类型
    ,sztyp as sztyp -- 收支类型
    ,sndbanref as sndbanref -- 发报行原始编号
    ,orcact as orcact -- 汇款人帐号
    ,pyeact as pyeact -- 收款人帐号
    ,canflg as canflg -- 退汇标志
    ,nraflg as nraflg -- nra标志
    ,qsqdbh as qsqdbh -- 清算渠道
    ,zjcflg as zjcflg -- 跨境资金池标识
    ,edtyp as edtyp -- 资金池业务类型
    ,basamt as basamt -- 资金池业务本金
    ,intamt as intamt -- 资金池业务利息
    ,stzfref as stzfref -- 受托支付编号
    ,duebillno as duebillno -- 受托支付出账借据号
    ,gpiflg as gpiflg -- gpi业务标识
    ,acstyp as acstyp -- gpi mt199报文反馈码
    ,qufflg as qufflg -- 询价标识（线上汇款业务是否有做过询价）
    ,feeacc as feeacc -- 扣费账号（线上汇款业务的费用承担方为our时带入客户扣费账号）
    ,resno as resno -- 限制编号
    ,' ' as isbxt -- 是否北向通
    ,0 as bxtamt -- 金额
    ,0 as bxtsamt -- 北向通金额
    ,' ' as iskds -- 是否跨境电商标识
    ,' ' as sbflg -- 申报标识
    ,start_dt as start_dt -- 开始时间
    ,end_dt as end_dt -- 结束时间
    ,id_mark as id_mark -- 增删标志
    ,etl_timestamp as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.isbs_cpd_bak${batch_date}
where end_dt = to_date(tb.end_dt,'yyyymmdd');

commit;

end loop;
end;
/

