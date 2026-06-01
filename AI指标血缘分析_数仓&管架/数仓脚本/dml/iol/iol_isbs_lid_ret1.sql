/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_isbs_lid
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
                       FROM isbs_lid_bak${batch_date})
              WHERE RN = 1
 ) loop

  select count(partition_name) into v_var 
    from user_tab_partitions 
   where substr(partition_name,3) = tb.end_dt 
     and table_name = upper('isbs_lid');
  
  if v_var <> 0 then 
    execute immediate 'alter table isbs_lid drop partition p_' || tb.end_dt;
  end if;
  
    v_sql :='alter table isbs_lid add partition p_' || tb.end_dt || ' values(to_date(' || tb.end_dt || ',''yyyymmdd''))';
    
    execute immediate v_sql;

  
   -- 回插所有数据    
   
insert /*+ append */ into ${iol_schema}.isbs_lid(
            inr -- 进口信用证id号
            ,ownref -- 参考号
            ,nam -- 标识交易的外部显示名称
            ,ownusr -- 参考号
            ,credat -- 开证或注册日期
            ,opndat -- 开证日期
            ,clsdat -- 结束日期
            ,advnam -- 通知行名称
            ,advref -- 通知行参考号
            ,amedat -- 上次修改日期
            ,amenbr -- 修改次数
            ,aplnam -- 申请人名称
            ,aplref -- 申请人参考号
            ,avbby -- 指定方式
            ,avbwth -- 指定方式
            ,bennam -- 收益人名字
            ,benref -- 受益人参考号
            ,chato -- 费用流向
            ,cnfdet -- 保兑状态
            ,expdat -- 效期，指定信用证的效期
            ,expplc -- 交单地点
            ,lcrtyp -- 信用证的格式
            ,nomspc -- 规格数量
            ,nomtop -- 溢短装
            ,nomton -- 溢短装
            ,preadvdt -- 预通知日期
            ,rmbact -- 偿付行用户帐号
            ,rmbcha -- 偿付行费用
            ,rmbflg -- 偿付标志
            ,shpdat -- 装船日期
            ,shpfro -- 装船地点
            ,porloa -- 装货港
            ,pordis -- 卸货港
            ,shppar -- 分装
            ,shpto -- 运货地点
            ,shptrs -- 转载[shptrs]
            ,stacty -- 国家代码
            ,stagod -- 货物代码
            ,utlnbr -- 利用数目
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
            ,dflg -- 
            ,guaflg -- 
            ,tratyp -- 
            ,opnamo -- 
            ,ameflg -- 
            ,cretyp -- 
            ,tadtyp -- 
            ,shpins -- 
            ,sermod -- 
            ,serfro -- 
            ,negflg -- 
            ,comflg -- 
            ,insdat -- 
            ,shppars18 -- 
            ,shptrss18 -- 
            ,spcbenflg -- 
            ,spcrcbflg -- 
            ,prepertxts18 -- 
            ,prepers18 -- 
            ,zytyp -- 
            ,productname -- 
			            ,contractno -- 
            ,concur -- 
            ,conamt -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
            inr -- 进口信用证id号
            ,ownref -- 参考号
            ,nam -- 标识交易的外部显示名称
            ,ownusr -- 参考号
            ,credat -- 开证或注册日期
            ,opndat -- 开证日期
            ,clsdat -- 结束日期
            ,advnam -- 通知行名称
            ,advref -- 通知行参考号
            ,amedat -- 上次修改日期
            ,amenbr -- 修改次数
            ,aplnam -- 申请人名称
            ,aplref -- 申请人参考号
            ,avbby -- 指定方式
            ,avbwth -- 指定方式
            ,bennam -- 收益人名字
            ,benref -- 受益人参考号
            ,chato -- 费用流向
            ,cnfdet -- 保兑状态
            ,expdat -- 效期，指定信用证的效期
            ,expplc -- 交单地点
            ,lcrtyp -- 信用证的格式
            ,nomspc -- 规格数量
            ,nomtop -- 溢短装
            ,nomton -- 溢短装
            ,preadvdt -- 预通知日期
            ,rmbact -- 偿付行用户帐号
            ,rmbcha -- 偿付行费用
            ,rmbflg -- 偿付标志
            ,shpdat -- 装船日期
            ,shpfro -- 装船地点
            ,porloa -- 装货港
            ,pordis -- 卸货港
            ,shppar -- 分装
            ,shpto -- 运货地点
            ,shptrs -- 转载[shptrs]
            ,stacty -- 国家代码
            ,stagod -- 货物代码
            ,utlnbr -- 利用数目
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
            ,dflg -- 
            ,guaflg -- 
            ,tratyp -- 
            ,opnamo -- 
            ,ameflg -- 
            ,cretyp -- 
            ,tadtyp -- 
            ,shpins -- 
            ,sermod -- 
            ,serfro -- 
            ,negflg -- 
            ,comflg -- 
            ,insdat -- 
            ,shppars18 -- 
            ,shptrss18 -- 
            ,spcbenflg -- 
            ,spcrcbflg -- 
            ,prepertxts18 -- 
            ,prepers18 -- 
            ,zytyp -- 
            ,' ' as productname -- 
			,' ' as contractno -- 
            ,' ' as concur -- 
            ,0 as conamt -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
from isbs_lid_bak${batch_date}
where end_dt = to_date(tb.end_dt,'yyyymmdd');
commit;

end loop;
end;
/
