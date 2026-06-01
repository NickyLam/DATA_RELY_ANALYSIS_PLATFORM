/*
Purpose:    偏源模型层-O层拉链算法回插脚本
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ICMS_FKD_HOUSE_LIST_ret1
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
                       FROM ICMS_FKD_HOUSE_LIST_bak${batch_date})
              WHERE RN = 1
 ) loop

  select count(partition_name) into v_var 
    from user_tab_partitions 
   where substr(partition_name,3) = tb.end_dt 
     and table_name = upper('ICMS_FKD_HOUSE_LIST');
  
  if v_var <> 0 then 
    execute immediate 'alter table ICMS_FKD_HOUSE_LIST drop partition p_' || tb.end_dt;
  end if;
  
    v_sql :='alter table ICMS_FKD_HOUSE_LIST add partition p_' || tb.end_dt || ' values(to_date(' || tb.end_dt || ',''yyyymmdd''))';
    
    execute immediate v_sql;

  
-- 回插备份表的所有数据    
   
insert /*+ append */ into ${iol_schema}.ICMS_FKD_HOUSE_LIST(
            serialno -- 主键
            ,areaname -- 区域名称
            ,buildingcode -- 楼号
            ,cusnamehire -- 承租人
            ,startdatehire -- 租赁起始日期
            ,obligee -- 上手权利人
            ,spareroomisclearinghouse -- 备用房是否清房
            ,titlecertificategettime -- 土地使用权起始日期
            ,cityareacode -- 城市编码
            ,spareroomcount -- 备用房数量
            ,obligeeind -- 主借人权利人标志
            ,housetype -- 房屋结构类型
            ,certcodehire -- 承租人证件号码
            ,assessmenttype -- 评估方式
            ,formalprice -- 正式评估价值
            ,hsobligeerelative -- 产权共有人关系
            ,hsovergroundarea -- 地上面积
            ,housestatus -- 房屋状态
            ,projectname -- 楼盘地址（小区名称）
            ,islease -- 是否出租
            ,gettime -- 产权证书取得时间
            ,mortgageamt -- 上手抵押金额
            ,roomsize -- 房屋面积
            ,leasetime -- 出租时间
            ,hsisbasement -- 有无地下室
            ,housepurpose -- 房屋用途
            ,remark -- 备注
            ,enddatehire -- 租赁终止日期
            ,coownership -- 共有情况
            ,migtflag -- 迁移标志：crsrcrilcupl
            ,hsbasementarea -- 地下面积
            ,bkprice -- 贝壳网房产评估价值
            ,cityname -- 城市名称
            ,lineprice -- 线上评估价值
            ,hsupperinmortgagedate -- 入抵日期
            ,hsupperoutmortgagedate -- 解抵日期
            ,certtypehire -- 承租人证件类型
            ,relativeserialno -- 业务流水号
            ,areacode -- 区域编码
            ,projectid -- 楼盘编号
            ,isvacant -- 是否空置
            ,getmode -- 取得方式
            ,propertyrightduedate -- 土地使用权到期日期
            ,hsdecoratestate -- 房产装修情况
            ,pledgeind -- 是否本次抵押
            ,hscoveredarea -- 建筑面积
            ,mourent -- 月租金
            ,frontcode -- 朝向
            ,rentcycle -- 租金收缴周期
            ,propertytype -- 房产类型
            ,floorno -- 楼层
            ,roomno -- 单元室
            ,buildingdate -- 建成年份
            ,isclearinghouse -- 是否清房
            ,landcategory -- 土地性质
            ,spareroomaddr -- 备用房地址
            ,gurtrate -- 担保率
            ,projectaddr -- 楼盘位置
            ,assessmentcom -- 评估公司名称
            ,partnerobligeeind -- 配偶权利人标志
            ,totalfloor -- 总楼层
            ,isevlbld -- 是否电梯楼
            ,contmode -- 房产所属人联系方式
            ,custname -- 房产所属人姓名
            ,propertydueyear -- 土地使用年限
            ,valuationkh -- 客户录入评估总价
            ,iscompleted -- 
            ,yearlyrental -- 
            ,houseid -- 
            ,valuationdzy -- 
            ,address -- 
            ,reltype -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
            serialno -- 主键
            ,areaname -- 区域名称
            ,buildingcode -- 楼号
            ,cusnamehire -- 承租人
            ,startdatehire -- 租赁起始日期
            ,obligee -- 上手权利人
            ,spareroomisclearinghouse -- 备用房是否清房
            ,titlecertificategettime -- 土地使用权起始日期
            ,cityareacode -- 城市编码
            ,spareroomcount -- 备用房数量
            ,obligeeind -- 主借人权利人标志
            ,housetype -- 房屋结构类型
            ,certcodehire -- 承租人证件号码
            ,assessmenttype -- 评估方式
            ,formalprice -- 正式评估价值
            ,hsobligeerelative -- 产权共有人关系
            ,hsovergroundarea -- 地上面积
            ,housestatus -- 房屋状态
            ,projectname -- 楼盘地址（小区名称）
            ,islease -- 是否出租
            ,gettime -- 产权证书取得时间
            ,mortgageamt -- 上手抵押金额
            ,roomsize -- 房屋面积
            ,leasetime -- 出租时间
            ,hsisbasement -- 有无地下室
            ,housepurpose -- 房屋用途
            ,remark -- 备注
            ,enddatehire -- 租赁终止日期
            ,coownership -- 共有情况
            ,migtflag -- 迁移标志：crsrcrilcupl
            ,hsbasementarea -- 地下面积
            ,bkprice -- 贝壳网房产评估价值
            ,cityname -- 城市名称
            ,lineprice -- 线上评估价值
            ,hsupperinmortgagedate -- 入抵日期
            ,hsupperoutmortgagedate -- 解抵日期
            ,certtypehire -- 承租人证件类型
            ,relativeserialno -- 业务流水号
            ,areacode -- 区域编码
            ,projectid -- 楼盘编号
            ,isvacant -- 是否空置
            ,getmode -- 取得方式
            ,propertyrightduedate -- 土地使用权到期日期
            ,hsdecoratestate -- 房产装修情况
            ,pledgeind -- 是否本次抵押
            ,hscoveredarea -- 建筑面积
            ,mourent -- 月租金
            ,frontcode -- 朝向
            ,rentcycle -- 租金收缴周期
            ,propertytype -- 房产类型
            ,floorno -- 楼层
            ,roomno -- 单元室
            ,buildingdate -- 建成年份
            ,isclearinghouse -- 是否清房
            ,landcategory -- 土地性质
            ,spareroomaddr -- 备用房地址
            ,gurtrate -- 担保率
            ,projectaddr -- 楼盘位置
            ,assessmentcom -- 评估公司名称
            ,partnerobligeeind -- 配偶权利人标志
            ,totalfloor -- 总楼层
            ,isevlbld -- 是否电梯楼
            ,contmode -- 房产所属人联系方式
            ,custname -- 房产所属人姓名
            ,propertydueyear -- 土地使用年限
            ,valuationkh -- 客户录入评估总价
            ,' ' AS iscompleted -- 
            ,0 AS yearlyrental -- 
            ,' ' AS houseid -- 
            ,0 AS valuationdzy -- 
            ,' ' AS address -- 
            ,' ' AS reltype -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
from ${iol_schema}.ICMS_FKD_HOUSE_LIST_bak${batch_date}
where end_dt = to_date(tb.end_dt,'yyyymmdd');
commit;


end loop;
end;
/
