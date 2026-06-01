/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_isbs_gid
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
                       FROM isbs_gid_bak${batch_date})
              WHERE RN = 1
 ) loop

  select count(partition_name) into v_var 
    from user_tab_partitions 
   where substr(partition_name,3) = tb.end_dt 
     and table_name = upper('isbs_gid');
  
  if v_var <> 0 then 
    execute immediate 'alter table isbs_gid drop partition p_' || tb.end_dt;
  end if;
  
    v_sql :='alter table isbs_gid add partition p_' || tb.end_dt || ' values(to_date(' || tb.end_dt || ',''yyyymmdd''))';
    
    execute immediate v_sql;

  
   -- 回插所有数据    
 
insert /*+ append */ into ${iol_schema}.isbs_gid(
            inr -- 保函内部ID号
            ,ownref -- 参考号
            ,nam -- 交易名称
            ,ownusr -- 负责人
            ,credat -- 创建日期
            ,opndat -- 保函生效日，定义保函有效的开始日期
            ,clsdat -- 结束日期
            ,oldref -- 以前的业务号
            ,amedat -- 最后一次修改日期
            ,orddat -- 客户订单日期
            ,amenbr -- 修改次数
            ,pndclm -- 为决的索偿次数
            ,chato -- 费用流向，保函开立GITOPN交易中业务人员手工选择                                                                          1. On applicant side      赋值U                                                                                                                 2.On beneficariy side   赋值B                                                                                                      3.Other  赋值O
            ,expdat -- 保函的到期日，定义保函的期满日期
            ,liadat -- liability定义负载的有效期
            ,stacty -- Country Code
            ,ver -- 版本号
            ,hndtyp -- 保函开立类型
            ,gidtxtmodflg -- 修改交易文本
            ,gtxinr -- 产生文本INR
            ,giduil -- 语言
            ,expflg -- 效期标志
            ,liaflg -- 选择赋值X,不选赋值空
            ,orcdat -- 初始交易日期, 显示初始保函的日期
            ,orcref -- 合同号
            ,orccur -- 初始交易币种
            ,orcamt -- 初始交易金额
            ,orcrat -- 初始交易汇率
            ,sndto -- 保函发给
            ,purcan -- 取消原因
            ,tenref -- 
            ,tendat -- 
            ,avidat -- 
            ,tenclsdat -- 
            ,decrea -- 
            ,jurplc -- 
            ,jurlaw -- 
            ,acc -- 
            ,resflg -- 
            ,stagod -- 
            ,redamt -- 
            ,redcur -- 
            ,reddat -- 
            ,outcur -- 
            ,outamt -- 
            ,cnfsta -- 
            ,partcon -- 
            ,cnfdat -- 
            ,cnfflg -- 
            ,revflg -- 
            ,etyextkey -- 
            ,gartyp -- 
            ,trmdat -- 
            ,legfrm -- 
            ,inudat -- 
            ,feecoldat -- 
            ,bchkeyinr -- 
            ,branchinr -- 
            ,teskeyunc -- 
            ,juscod -- 
            ,cunqii -- 
            ,bilvvv -- 
            ,decflg -- 
            ,rskrat -- 
            ,cshpct -- 
            ,guaflg -- 
            ,fincod -- 
            ,fintyp -- 
            ,relcshpct -- 
            ,garfin -- 
            ,purpos -- 
            ,plsiss -- 代开标志
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
            inr -- 保函内部ID号
            ,ownref -- 参考号
            ,nam -- 交易名称
            ,ownusr -- 负责人
            ,credat -- 创建日期
            ,opndat -- 保函生效日，定义保函有效的开始日期
            ,clsdat -- 结束日期
            ,oldref -- 以前的业务号
            ,amedat -- 最后一次修改日期
            ,orddat -- 客户订单日期
            ,amenbr -- 修改次数
            ,pndclm -- 为决的索偿次数
            ,chato -- 费用流向，保函开立GITOPN交易中业务人员手工选择                                                                          1. On applicant side      赋值U                                                                                                                 2.On beneficariy side   赋值B                                                                                                      3.Other  赋值O
            ,expdat -- 保函的到期日，定义保函的期满日期
            ,liadat -- liability定义负载的有效期
            ,stacty -- Country Code
            ,ver -- 版本号
            ,hndtyp -- 保函开立类型
            ,gidtxtmodflg -- 修改交易文本
            ,gtxinr -- 产生文本INR
            ,giduil -- 语言
            ,expflg -- 效期标志
            ,liaflg -- 选择赋值X,不选赋值空
            ,orcdat -- 初始交易日期, 显示初始保函的日期
            ,orcref -- 合同号
            ,orccur -- 初始交易币种
            ,orcamt -- 初始交易金额
            ,orcrat -- 初始交易汇率
            ,sndto -- 保函发给
            ,purcan -- 取消原因
            ,tenref -- 
            ,tendat -- 
            ,avidat -- 
            ,tenclsdat -- 
            ,decrea -- 
            ,jurplc -- 
            ,jurlaw -- 
            ,acc -- 
            ,resflg -- 
            ,stagod -- 
            ,redamt -- 
            ,redcur -- 
            ,reddat -- 
            ,outcur -- 
            ,outamt -- 
            ,cnfsta -- 
            ,partcon -- 
            ,cnfdat -- 
            ,cnfflg -- 
            ,revflg -- 
            ,etyextkey -- 
            ,gartyp -- 
            ,trmdat -- 
            ,legfrm -- 
            ,inudat -- 
            ,feecoldat -- 
            ,bchkeyinr -- 
            ,branchinr -- 
            ,teskeyunc -- 
            ,juscod -- 
            ,cunqii -- 
            ,bilvvv -- 
            ,decflg -- 
            ,rskrat -- 
            ,cshpct -- 
            ,guaflg -- 
            ,fincod -- 
            ,fintyp -- 
            ,relcshpct -- 
            ,garfin -- 
            ,purpos -- 
            ,' ' as plsiss -- 代开标志
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
from ${iol_schema}.isbs_gid_bak${batch_date}
where end_dt = to_date(tb.end_dt,'yyyymmdd');
commit;

end loop;
end;
/
