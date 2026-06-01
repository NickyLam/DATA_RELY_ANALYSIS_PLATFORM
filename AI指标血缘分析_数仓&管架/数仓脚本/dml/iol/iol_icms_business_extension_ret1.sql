/*
Purpose:    偏源模型层-O层拉链算法回插脚本
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ICMS_BUSINESS_EXTENSION_ret1
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
                       FROM ICMS_BUSINESS_EXTENSION_bak${batch_date})
              WHERE RN = 1
 ) loop

  select count(partition_name) into v_var 
    from user_tab_partitions 
   where substr(partition_name,3) = tb.end_dt 
     and table_name = upper('ICMS_BUSINESS_EXTENSION');
  
  if v_var <> 0 then 
    execute immediate 'alter table ICMS_BUSINESS_EXTENSION drop partition p_' || tb.end_dt;
  end if;
  
    v_sql :='alter table ICMS_BUSINESS_EXTENSION add partition p_' || tb.end_dt || ' values(to_date(' || tb.end_dt || ',''yyyymmdd''))';
    
    execute immediate v_sql;

  
-- 回插备份表的所有数据    
   
insert /*+ append */ into ${iol_schema}.ICMS_BUSINESS_EXTENSION(
            serialno -- 信息流水号
            ,occurtime -- 发生时间
            ,transactionflag -- 交易标志
            ,voucherno -- 凭证号码
            ,overduefloat -- 逾期贷款利率浮动比例
            ,extendflag -- 更新标志
            ,rategenre -- 利率重定价
            ,occurdate -- 发生日期
            ,extendtermday -- 展期期限日
            ,orgid -- 创建机构
            ,ratefloat -- (Del)浮动利率
            ,lastmaturity -- 原到期日
            ,putoutno -- 出帐号
            ,relativeduebillno -- 关联借据号
            ,extendtermmonth -- 展期期限月
            ,extendrate -- 展期利率
            ,lastrate -- 原利率
            ,extensionsum -- 展期金额
            ,overduerate -- 逾期贷款执行利率
            ,contractno -- 展期合同号
            ,extendtermyear -- 展期期限年
            ,baserate -- (Del)基准利率
            ,lastputoutdate -- 展期前起始日
            ,migtflag -- 迁移标志：crsrcrilcupl
            ,businessrate -- 利率
            ,userid -- 操作员
            ,extendputoutdate -- 受托支付序号
            ,baseratetype -- (Del)基准利率类型
            ,lastsum -- 展期前金额
            ,extendmaturity -- 展期后到期日
            ,remark -- 备注
            ,rateadjustfrequency -- 利率调整周期
            ,rateadjusttype -- 利率调整方式利率调整方式(1立即2次年初3次年对月对日4按月调5下一个还款日调整)
            ,orderno -- 预约编号
            ,nextsettlementdate -- 
            ,extendeffectdate -- 
            ,extendrateeffectdate -- 
            ,extendrepayplaneffectdate -- 
            ,newrepaytype -- 
            ,finalmerger -- 
            ,repaydate -- 
            ,repaycycle -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
            serialno -- 信息流水号
            ,occurtime -- 发生时间
            ,transactionflag -- 交易标志
            ,voucherno -- 凭证号码
            ,overduefloat -- 逾期贷款利率浮动比例
            ,extendflag -- 更新标志
            ,rategenre -- 利率重定价
            ,occurdate -- 发生日期
            ,extendtermday -- 展期期限日
            ,orgid -- 创建机构
            ,ratefloat -- (Del)浮动利率
            ,lastmaturity -- 原到期日
            ,putoutno -- 出帐号
            ,relativeduebillno -- 关联借据号
            ,extendtermmonth -- 展期期限月
            ,extendrate -- 展期利率
            ,lastrate -- 原利率
            ,extensionsum -- 展期金额
            ,overduerate -- 逾期贷款执行利率
            ,contractno -- 展期合同号
            ,extendtermyear -- 展期期限年
            ,baserate -- (Del)基准利率
            ,lastputoutdate -- 展期前起始日
            ,migtflag -- 迁移标志：crsrcrilcupl
            ,businessrate -- 利率
            ,userid -- 操作员
            ,extendputoutdate -- 受托支付序号
            ,baseratetype -- (Del)基准利率类型
            ,lastsum -- 展期前金额
            ,extendmaturity -- 展期后到期日
            ,remark -- 备注
            ,rateadjustfrequency -- 利率调整周期
            ,rateadjusttype -- 利率调整方式利率调整方式(1立即2次年初3次年对月对日4按月调5下一个还款日调整)
            ,orderno -- 预约编号
            ,' ' AS nextsettlementdate -- 
            ,to_date('00010101','yyyymmdd') AS extendeffectdate -- 
            ,to_date('00010101','yyyymmdd') AS extendrateeffectdate -- 
            ,to_date('00010101','yyyymmdd') AS extendrepayplaneffectdate -- 
            ,' ' AS newrepaytype -- 
            ,' ' AS finalmerger -- 
            ,' ' AS repaydate -- 
            ,' ' AS repaycycle -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
from ${iol_schema}.ICMS_BUSINESS_EXTENSION_bak${batch_date}
where end_dt = to_date(tb.end_dt,'yyyymmdd');
commit;


end loop;
end;
/
