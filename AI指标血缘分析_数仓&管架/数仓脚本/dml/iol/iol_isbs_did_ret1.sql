/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_isbs_did
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
                       FROM isbs_did_bak${batch_date})
              WHERE RN = 1
 ) loop

  select count(partition_name) into v_var 
    from user_tab_partitions 
   where substr(partition_name,3) = tb.end_dt 
     and table_name = upper('isbs_did');
  
  if v_var <> 0 then 
    execute immediate 'alter table isbs_did drop partition p_' || tb.end_dt;
  end if;
  
    v_sql :='alter table isbs_did add partition p_' || tb.end_dt || ' values(to_date(' || tb.end_dt || ',''yyyymmdd''))';
    
    execute immediate v_sql;

  
   -- 回插所有数据    
   
insert /*+ append */ into ${iol_schema}.isbs_did(
            inr -- 
            ,ownref -- 
            ,nam -- 
            ,ownusr -- 
            ,credat -- 
            ,opndat -- 
            ,clsdat -- 
            ,advnam -- 
            ,advref -- 
            ,amedat -- 
            ,amenbr -- 
            ,aplnam -- 
            ,aplref -- 
            ,avbby -- 
            ,avbwth -- 
            ,bennam -- 
            ,benref -- 
            ,chato -- 
            ,cnfdet -- 
            ,expdat -- 
            ,expplc -- 
            ,lcrtyp -- 
            ,nomspc -- 
            ,nomtop -- 
            ,nomton -- 
            ,preadvdt -- 
            ,rmbact -- 
            ,rmbcha -- 
            ,rmbflg -- 
            ,shpdat -- 
            ,shpfro -- 
            ,porloa -- 
            ,pordis -- 
            ,shppar -- 
            ,shpto -- 
            ,shptrs -- 
            ,stacty -- 
            ,stagod -- 
            ,utlnbr -- 
            ,advnbr -- 
            ,redclsflg -- 
            ,ver -- 
            ,lcityp -- 
            ,b2binr -- 
            ,b2bref -- 
            ,revnbr -- 
            ,revtimes -- 
            ,revflg -- 
            ,revawapl -- 
            ,revdat -- 
            ,revcum -- 
            ,revtyp -- 
            ,initpty -- 
            ,resflg -- 
            ,apprul -- 
            ,apprulrmb -- 
            ,apprultxt -- 
            ,autdat -- 
            ,etyextkey -- 
            ,tenmaxday -- 
            ,branchinr -- 
            ,bchkeyinr -- 
            ,decflg -- 
            ,cshpct -- 
            ,isstyp -- 
            ,fincod -- 
            ,fintyp -- 
            ,relcshpct -- 
            ,jjh -- 
            ,guaflg -- 
            ,tratyp -- 
            ,opnamo -- 
            ,ameflg -- 
            ,cretyp -- 
            ,tadtyp -- 
            ,shpins -- 
            ,sermod -- 
            ,serfro -- 
            ,comflg -- 
            ,insdat -- 
            ,contractno -- 
            ,negflg -- 
            ,elcflg -- 通过电证标志
            ,concur -- 合同币种
            ,conamt -- 合同金额
            ,rejame -- 拒绝修改标志
            ,cantyp -- 闭卷类型
            ,rejflg -- 拒绝通知标志
            ,tzref -- 通知行编号
            ,nomtop1 -- 上浮金额（elcs）
            ,nomton1 -- 下浮金额（elcs）
            ,zytyp -- 质押类型
			            ,productname -- 货物名称
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
            inr -- 
            ,ownref -- 
            ,nam -- 
            ,ownusr -- 
            ,credat -- 
            ,opndat -- 
            ,clsdat -- 
            ,advnam -- 
            ,advref -- 
            ,amedat -- 
            ,amenbr -- 
            ,aplnam -- 
            ,aplref -- 
            ,avbby -- 
            ,avbwth -- 
            ,bennam -- 
            ,benref -- 
            ,chato -- 
            ,cnfdet -- 
            ,expdat -- 
            ,expplc -- 
            ,lcrtyp -- 
            ,nomspc -- 
            ,nomtop -- 
            ,nomton -- 
            ,preadvdt -- 
            ,rmbact -- 
            ,rmbcha -- 
            ,rmbflg -- 
            ,shpdat -- 
            ,shpfro -- 
            ,porloa -- 
            ,pordis -- 
            ,shppar -- 
            ,shpto -- 
            ,shptrs -- 
            ,stacty -- 
            ,stagod -- 
            ,utlnbr -- 
            ,advnbr -- 
            ,redclsflg -- 
            ,ver -- 
            ,lcityp -- 
            ,b2binr -- 
            ,b2bref -- 
            ,revnbr -- 
            ,revtimes -- 
            ,revflg -- 
            ,revawapl -- 
            ,revdat -- 
            ,revcum -- 
            ,revtyp -- 
            ,initpty -- 
            ,resflg -- 
            ,apprul -- 
            ,apprulrmb -- 
            ,apprultxt -- 
            ,autdat -- 
            ,etyextkey -- 
            ,tenmaxday -- 
            ,branchinr -- 
            ,bchkeyinr -- 
            ,decflg -- 
            ,cshpct -- 
            ,isstyp -- 
            ,fincod -- 
            ,fintyp -- 
            ,relcshpct -- 
            ,jjh -- 
            ,guaflg -- 
            ,tratyp -- 
            ,opnamo -- 
            ,ameflg -- 
            ,cretyp -- 
            ,tadtyp -- 
            ,shpins -- 
            ,sermod -- 
            ,serfro -- 
            ,comflg -- 
            ,insdat -- 
            ,contractno -- 
            ,negflg -- 
            ,elcflg -- 通过电证标志
            ,concur -- 合同币种
            ,conamt -- 合同金额
            ,rejame -- 拒绝修改标志
            ,cantyp -- 闭卷类型
            ,rejflg -- 拒绝通知标志
            ,tzref -- 通知行编号
            ,nomtop1 -- 上浮金额（elcs）
            ,nomton1 -- 下浮金额（elcs）
            ,zytyp -- 质押类型
			            ,' ' as productname -- 货物名称
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
from ${iol_schema}.isbs_did_bak${batch_date}
where end_dt = to_date(tb.end_dt,'yyyymmdd');
commit;

end loop;
end;
/
