/*
Purpose:    偏源模型层-O层拉链算法回插脚本
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ICMS_FKD_REL_LIST_ret1
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
                       FROM ICMS_FKD_REL_LIST_bak${batch_date})
              WHERE RN = 1
 ) loop

  select count(partition_name) into v_var 
    from user_tab_partitions 
   where substr(partition_name,3) = tb.end_dt 
     and table_name = upper('ICMS_FKD_REL_LIST');
  
  if v_var <> 0 then 
    execute immediate 'alter table ICMS_FKD_REL_LIST drop partition p_' || tb.end_dt;
  end if;
  
    v_sql :='alter table ICMS_FKD_REL_LIST add partition p_' || tb.end_dt || ' values(to_date(' || tb.end_dt || ',''yyyymmdd''))';
    
    execute immediate v_sql;

  
-- 回插备份表的所有数据    
   
insert /*+ append */ into ${iol_schema}.ICMS_FKD_REL_LIST(
            serialno -- 主键
            ,relativeserialno -- 业务流水号
            ,reltyp -- 关联人类型
            ,relname -- 关联人姓名
            ,reltelno -- 关联人手机号码
            ,relidtype -- 关联人证件类型
            ,relidno -- 关联人证件号码
            ,relrelationship -- 与主借款人关系
            ,relfamilycityid -- 关联人居住地址城市编号
            ,relfamilyaddr -- 关联人居住地址
            ,relmarriage -- 关联人婚姻状况
            ,relpartnername -- 关联人配偶姓名
            ,relpartnertelno -- 关联人配偶手机号码
            ,relpartneridtype -- 关联人配偶证件类型
            ,relpartneridno -- 关联人配偶证件号码
            ,cusid -- 客户号
            ,fqzresult -- 反欺诈结果
            ,zxresult -- 征信结果
            ,remark -- 备注
            ,updatedate -- 更新时间
            ,naturecategoryrel -- 关联人户籍性质
            ,eduexperiencerel -- 关联人学历
            ,ownshare -- 抵押人对抵押物拥有的份额
            ,agriflg -- 是否农户
            ,businessesflag -- 客户性质
            ,oblityp -- 智贷去权利人类型
            ,pledgepkno -- 智贷质押物信息主键
            ,conshr -- 智贷权利人共有份额
            ,immovables -- 不动产共有情况
            ,naturecategoryrelsps -- 关联人配偶户籍性质
            ,relidexpire -- 关联人证件到期日
            ,migtflag -- 迁移标志：crs rcr ilc upl
            ,relnation -- 关联人国籍
            ,relcareer -- 关联人职业
            ,relsex -- 关联人性别
            ,relcareercomm -- 关联人职业备注信息
            ,relpartneridexpire -- 关联人配偶证件失效日期
            ,relpartnernation -- 关联人配偶国籍
            ,relpartnercareer -- 关联人配偶职业
            ,relpartnersex -- 关联人配偶性别
            ,relpartneraddr -- 关联人配偶居住地址
            ,relpartnercareercomm -- 关联人配偶职业备注信息
            ,relideffective -- 
            ,taxqueryflag -- 
            ,taxauthorizeno -- 
            ,taxpayeridentityno -- 
            ,coboinvtstkperc -- 
            ,relannualincome -- 
            ,relauthorizerroleflag -- 
            ,wthrguart -- 
            ,isrelatemaxentholder -- 
            ,relationship -- 
            ,relcorpname -- 
            ,relcorpprop -- 
            ,relemplmyears -- 
            ,relcorpadr -- 
            ,relcorptel -- 
            ,reltaxaftermonincome -- 
            ,relethnic -- 
            ,relresiadr -- 
            ,relwthrhouse -- 
            ,relsocscrcontsmont -- 
            ,relfundcontsmont -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
            serialno -- 主键
            ,relativeserialno -- 业务流水号
            ,reltyp -- 关联人类型
            ,relname -- 关联人姓名
            ,reltelno -- 关联人手机号码
            ,relidtype -- 关联人证件类型
            ,relidno -- 关联人证件号码
            ,relrelationship -- 与主借款人关系
            ,relfamilycityid -- 关联人居住地址城市编号
            ,relfamilyaddr -- 关联人居住地址
            ,relmarriage -- 关联人婚姻状况
            ,relpartnername -- 关联人配偶姓名
            ,relpartnertelno -- 关联人配偶手机号码
            ,relpartneridtype -- 关联人配偶证件类型
            ,relpartneridno -- 关联人配偶证件号码
            ,cusid -- 客户号
            ,fqzresult -- 反欺诈结果
            ,zxresult -- 征信结果
            ,remark -- 备注
            ,updatedate -- 更新时间
            ,naturecategoryrel -- 关联人户籍性质
            ,eduexperiencerel -- 关联人学历
            ,ownshare -- 抵押人对抵押物拥有的份额
            ,agriflg -- 是否农户
            ,businessesflag -- 客户性质
            ,oblityp -- 智贷去权利人类型
            ,pledgepkno -- 智贷质押物信息主键
            ,conshr -- 智贷权利人共有份额
            ,immovables -- 不动产共有情况
            ,naturecategoryrelsps -- 关联人配偶户籍性质
            ,relidexpire -- 关联人证件到期日
            ,migtflag -- 迁移标志：crs rcr ilc upl
            ,relnation -- 关联人国籍
            ,relcareer -- 关联人职业
            ,relsex -- 关联人性别
            ,relcareercomm -- 关联人职业备注信息
            ,relpartneridexpire -- 关联人配偶证件失效日期
            ,relpartnernation -- 关联人配偶国籍
            ,relpartnercareer -- 关联人配偶职业
            ,relpartnersex -- 关联人配偶性别
            ,relpartneraddr -- 关联人配偶居住地址
            ,relpartnercareercomm -- 关联人配偶职业备注信息
            ,to_date('00010101','yyyymmdd') AS relideffective -- 
            ,' ' AS taxqueryflag -- 
            ,' ' AS taxauthorizeno -- 
            ,' ' AS taxpayeridentityno -- 
            ,' ' AS coboinvtstkperc -- 
            ,0 AS relannualincome -- 
            ,' ' AS relauthorizerroleflag -- 
            ,' ' AS wthrguart -- 
            ,' ' AS isrelatemaxentholder -- 
            ,to_date('00010101','yyyymmdd') AS relationship -- 
            ,' ' AS relcorpname -- 
            ,' ' AS relcorpprop -- 
            ,0 AS relemplmyears -- 
            ,' ' AS relcorpadr -- 
            ,' ' AS relcorptel -- 
            ,0 AS reltaxaftermonincome -- 
            ,' ' AS relethnic -- 
            ,' ' AS relresiadr -- 
            ,' ' AS relwthrhouse -- 
            ,' ' AS relsocscrcontsmont -- 
            ,' ' AS relfundcontsmont -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
from ${iol_schema}.ICMS_FKD_REL_LIST_bak${batch_date}
where end_dt = to_date(tb.end_dt,'yyyymmdd');
commit;


end loop;
end;
/
