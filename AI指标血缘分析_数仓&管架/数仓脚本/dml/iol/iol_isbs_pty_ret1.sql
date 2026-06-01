/*
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_isbs_pty_ret1
CreateDate: 20250122
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
                       FROM isbs_pty_bak${batch_date})
              WHERE RN = 1
 ) loop

  select count(partition_name) into v_var
    from user_tab_partitions
   where substr(partition_name,3) = tb.end_dt
     and table_name = upper('isbs_pty');

  if v_var <> 0 then
    execute immediate 'alter table isbs_pty drop partition p_' || tb.end_dt;
  end if;

    v_sql :='alter table isbs_pty add partition p_' || tb.end_dt || ' values(to_date(' || tb.end_dt || ',''yyyymmdd''))';

    execute immediate v_sql;

-- 回插所有数据

insert /*+ append */ into ${iol_schema}.isbs_pty (
    inr -- 内部唯一id号
    ,extkey -- 客户号
    ,nam -- 客户名称
    ,ptytyp -- 客户类型
    ,accusr -- 用户帐户的id
    ,hbkaccflg -- housebank帐户标志
    ,hbkconflg -- housebank用户环境标志
    ,hbkinr -- 银行inr
    ,heqaccflg -- 总行帐户标志
    ,heqconflg -- 总行环境标志
    ,heqinr -- 总行inr
    ,prfctr -- 收益中心
    ,resusr -- 客户经理
    ,rskcls -- 风险等级
    ,rskcty -- 风险国家
    ,rsktxt -- 风险文本描述
    ,uil -- 传输的语言
    ,ver -- 版本号
    ,akkbra -- akk商业区域
    ,akkcom -- akk公司id
    ,akkreg -- akk地区编号
    ,lidcndflg -- 特别l/c情况
    ,lidmaxdur -- l/c最大期限日
    ,trdcndflg -- 特别交易情况
    ,trdtentot -- 汇票的最大期限日maximum
    ,trdtenini -- 最初汇票期限initial
    ,trdtenext -- 汇票的最大延期日maximum
    ,trdextnmb -- 汇票最大延期数
    ,badcndflg -- 特别ba情况
    ,badtenext -- ba最大期限日
    ,adrsta -- 地址状态
    ,seltyp -- 客户信贷利率
    ,buytyp -- 客户借贷利率
    ,sla -- 服务等级
    ,etgextkey -- 实体组
    ,nam1 -- 中文名称chinese
    ,juscod -- 技术监督局编号
    ,bilvvv -- 上浮比率
    ,cunqii -- 流动资金贷款利率档次
    ,idcode -- 身份证号码
    ,idtype -- 客户类型
    ,bchkeyinr -- 所属分行inr
    ,clscty -- 国家的信用等级credit
    ,procod -- 区域代码province
    ,trnman -- 交易主体
    ,speeco -- 特殊经济区域
    ,idtyp1 -- id类型1
    ,ratstm -- 
    ,banktyp -- 银行类型
    ,godcus -- 
    ,imginr -- 影像流水号
    ,bankno -- 人行行号
    ,drccod -- 所属直接参与机构
    ,bnkkey -- 联系地址外部关键字
    ,bnkref -- ECIF同业客户号
    ,risran -- 反洗钱等级
    ,imginr2 -- 新客户签约书
    ,risrantxt -- 反洗钱等级描述
    ,idcodlst -- 证件号码集合
    ,idtyplst -- 证件类型集合
    ,iscrb -- 跨境电商/跨境B2B
    ,start_dt -- 开始时间
    ,end_dt -- 结束时间
    ,id_mark -- 增删标志
    ,etl_timestamp -- ETL处理时间戳
)
select
    inr as inr -- 内部唯一id号
    ,extkey as extkey -- 客户号
    ,nam as nam -- 客户名称
    ,ptytyp as ptytyp -- 客户类型
    ,accusr as accusr -- 用户帐户的id
    ,hbkaccflg as hbkaccflg -- housebank帐户标志
    ,hbkconflg as hbkconflg -- housebank用户环境标志
    ,hbkinr as hbkinr -- 银行inr
    ,heqaccflg as heqaccflg -- 总行帐户标志
    ,heqconflg as heqconflg -- 总行环境标志
    ,heqinr as heqinr -- 总行inr
    ,prfctr as prfctr -- 收益中心
    ,resusr as resusr -- 客户经理
    ,rskcls as rskcls -- 风险等级
    ,rskcty as rskcty -- 风险国家
    ,rsktxt as rsktxt -- 风险文本描述
    ,uil as uil -- 传输的语言
    ,ver as ver -- 版本号
    ,akkbra as akkbra -- akk商业区域
    ,akkcom as akkcom -- akk公司id
    ,akkreg as akkreg -- akk地区编号
    ,lidcndflg as lidcndflg -- 特别l/c情况
    ,lidmaxdur as lidmaxdur -- l/c最大期限日
    ,trdcndflg as trdcndflg -- 特别交易情况
    ,trdtentot as trdtentot -- 汇票的最大期限日maximum
    ,trdtenini as trdtenini -- 最初汇票期限initial
    ,trdtenext as trdtenext -- 汇票的最大延期日maximum
    ,trdextnmb as trdextnmb -- 汇票最大延期数
    ,badcndflg as badcndflg -- 特别ba情况
    ,badtenext as badtenext -- ba最大期限日
    ,adrsta as adrsta -- 地址状态
    ,seltyp as seltyp -- 客户信贷利率
    ,buytyp as buytyp -- 客户借贷利率
    ,sla as sla -- 服务等级
    ,etgextkey as etgextkey -- 实体组
    ,nam1 as nam1 -- 中文名称chinese
    ,juscod as juscod -- 技术监督局编号
    ,bilvvv as bilvvv -- 上浮比率
    ,cunqii as cunqii -- 流动资金贷款利率档次
    ,idcode as idcode -- 身份证号码
    ,idtype as idtype -- 客户类型
    ,bchkeyinr as bchkeyinr -- 所属分行inr
    ,clscty as clscty -- 国家的信用等级credit
    ,procod as procod -- 区域代码province
    ,trnman as trnman -- 交易主体
    ,speeco as speeco -- 特殊经济区域
    ,idtyp1 as idtyp1 -- id类型1
    ,ratstm as ratstm -- 
    ,banktyp as banktyp -- 银行类型
    ,godcus as godcus -- 
    ,imginr as imginr -- 影像流水号
    ,bankno as bankno -- 人行行号
    ,drccod as drccod -- 所属直接参与机构
    ,bnkkey as bnkkey -- 联系地址外部关键字
    ,bnkref as bnkref -- ECIF同业客户号
    ,' ' as risran -- 反洗钱等级
    ,' ' as imginr2 -- 新客户签约书
    ,' ' as risrantxt -- 反洗钱等级描述
    ,' ' as idcodlst -- 证件号码集合
    ,' ' as idtyplst -- 证件类型集合
    ,' ' as iscrb -- 跨境电商/跨境B2B
    ,start_dt as start_dt -- 开始时间
    ,end_dt as end_dt -- 结束时间
    ,id_mark as id_mark -- 增删标志
    ,etl_timestamp as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.isbs_pty_bak${batch_date}
where end_dt = to_date(tb.end_dt,'yyyymmdd');

commit;

end loop;
end;
/

